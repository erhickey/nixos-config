{ context, ... }:
{
  imports = [
    ./common
    ./${context}
  ];
}