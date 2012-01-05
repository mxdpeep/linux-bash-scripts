#!/bin/bash
#
# License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
#
# Filip Oscadal <filip@mxd.cz> http://mxd.cz/
# No Rights Reserved 2012, feel free to modify, use and distribute.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.


if [ -z "$3" ]
then
  echo -e "\nPing network range\n\nSyntax: $(basename $0) <subnet> <low> <hi>\nExample: $(basename $0) 192.168.1 1 10\n\n"
  exit 1
fi

NETWORK=$1
LO=$2
HI=$3

echo

is_alive_ping()
{
  local IP="$NETWORK.$1"
  echo Pinging $IP ▶
  ping -c 1 -w 1 $IP >/dev/null
  [ $? -eq 0 ] && echo ▶ $IP is up
}

for i in `seq $LO $HI`
do
  is_alive_ping $i
done

echo -e "\nDone.\n"
exit 0
