#!/usr/bin/env python3

"""pycal - Get ICS calendar events included in range from now to specified end

Usage:
  pycal.py
  pycal.py UNITS
  pycal.py UNITS UNIT_TYPE
  pycal.py [-n MINUTES |--notifications=MINUTES]
  pycal.py (-h | --help)
  pycal.py --version

Arguments:
  UNITS         Units to shift start date by [default: 1]
  UNIT_TYPE     Unit type to shift start date by (years|months|weeks|days|hours|minutes) [default: weeks]

Options:
  -n MINUTES --notifications=MINUTES    Get notifications for events starting in MINUTES or starting within one minute [default: 0]
  -h --help                             Show this screen
  -v --version                          Show version

"""

from datetime import datetime
from itertools import groupby
import os

import arrow
from docopt import docopt
from icalendar import Calendar
from schema import And, Schema, SchemaError, Use
import recurring_ical_events


class color:
   PURPLE = '\033[35m'
   CYAN = '\033[36m'
   DARKCYAN = '\033[36m'
   BLUE = '\033[34m'
   GREEN = '\033[32m'
   YELLOW = '\033[33m'
   RED = '\033[31m'
   BOLD = '\033[1m'
   UNDERLINE = '\033[4m'
   END = '\033[0m'


LOCATION_KEYWORDS = ['google', 'zoom']

def get_events(start, end):
    with open(os.path.expanduser('~/.config/pycal/calendar.ics')) as f:
        cal = Calendar.from_ical(f.read())
        return recurring_ical_events.of(cal).between(start, end)


def print_calendar(events, timezone):
    groups = groupby(
        sorted(events, key=lambda e: arrow.get(e.get('DTSTART').dt)),
        lambda e: e.get('DTSTART').dt.strftime('%A, %B %-d')
    )
    for k, es in groups:
        print(k)
        for e in es:
            print_event(e, timezone)


def get_event_url(event):
    google_conf = event.get('X-GOOGLE-CONFERENCE')
    if google_conf is not None:
        return google_conf
    loc = event.get('LOCATION')
    if loc is not None and any(kw in loc.lower() for kw in LOCATION_KEYWORDS):
        return loc
    return None


def print_event(event, timezone):
    start_time = event.get('DTSTART').dt
    end_time = event.get('DTEND').dt
    name = event.get('SUMMARY')

    if isinstance(start_time, datetime) and isinstance(end_time, datetime):
        start_time = arrow.get(start_time).to(timezone).format('HH:mm')
        end_time = arrow.get(end_time).to(timezone).format('HH:mm')
        url = get_event_url(event)
        url = f' - {color.BLUE}{url}{color.END}' if url is not None else ''
        print(f'\t{start_time} - {end_time}  {color.BOLD}{name}{color.END}{url}')
    else:
        print(f'\t   All Day     {color.BOLD}{name}{color.END}')


def print_notification(event, timezone, is_now=False):
    start_time = event.get('DTSTART').dt
    end_time = event.get('DTEND').dt
    name = event.get('SUMMARY')

    if isinstance(start_time, datetime) and isinstance(end_time, datetime):
        start_time = arrow.get(start_time).to(timezone).format('HH:mm')
        end_time = arrow.get(end_time).to(timezone).format('HH:mm')
        timeout = (1000 * 60 * 5) if is_now else (1000 * 60 * 10)
        urgency = 'critical' if is_now else 'normal'
        print(f'"{name}" "{start_time} - {end_time}" -t {timeout} -u {urgency}')
    else:
        if not is_now:
            print(f'"{name}" "All Day" -t {1000 * 60 * 5}')


def starting_in_filter(event, dt):
    start_time = event.get('DTSTART').dt
    return isinstance(start_time, datetime) and start_time.minute == dt.minute


def starting_now_filter(event):
    start_time = event.get('DTSTART').dt
    now = arrow.now().datetime
    return isinstance(start_time, datetime) and start_time.minute == now.minute


if __name__ == '__main__':
    args = docopt(__doc__, version='pycal version 0.1')
    args['UNITS'] = args['UNITS'] or '1'
    args['UNIT_TYPE'] = args['UNIT_TYPE'] or 'weeks'

    schema = Schema({
        '--help': Use(bool),
        '--version': Use(bool),
        '--notifications': Use(int),
        'UNITS': Use(int, error='UNITS should be an integer'),
        'UNIT_TYPE': And(str,
                         Use(str.lower),
                         lambda s: s in ('years', 'months', 'weeks', 'days', 'hours', 'minutes'),
                         error='Invalid UNIT_TYPE, should be one of: years months weeks days hours minutes'),
    })

    try:
        args = schema.validate(args)
    except SchemaError as e:
        exit(e)

    if args['--notifications'] == 0:
        start = arrow.now()
        end = start.shift(**{args['UNIT_TYPE']: args['UNITS']})
        events = get_events(start.datetime, end.datetime)
        print_calendar(events, 'local')
    else:
        start = arrow.now()
        end = start.shift(**{'minutes': args['--notifications']})
        events = get_events(start.datetime, end.datetime)
        soon_events = filter(lambda e: starting_in_filter(e, end.datetime), events)
        now_events = filter(lambda e: starting_now_filter(e), events)
        for e in now_events:
            print_notification(e, 'local', True)
        for e in soon_events:
            print_notification(e, 'local')
