#!/usr/bin/env bash

echo "Downloading jp-aggregated.zone from ipdeny ..."
wget -c -N http://www.ipdeny.com/ipblocks/data/aggregated/jp-aggregated.zone
echo "Downloading us-aggregated.zone from ipdeny ..."
wget -c -N http://www.ipdeny.com/ipblocks/data/aggregated/us-aggregated.zone
echo "Downloading kr-aggregated.zone from ipdeny ..."
wget -c -N http://www.ipdeny.com/ipblocks/data/aggregated/kr-aggregated.zone
# echo "Downloading cn-aggregated.zone from ipdeny ..."
# wget -c -N http://www.ipdeny.com/ipblocks/data/aggregated/cn-aggregated.zone
# echo "Downloading getProxyConfig from Telegram ..."
# wget -c -N -e "https_proxy=http://127.0.0.1:8080" https://core.telegram.org/getProxyConfig


format_exception () {
  echo "Formatting exception & geoip rules for $1 ..."

  echo "" > Resources/$1/$1_exception_temp.txt
  echo "# Exception rules" >> Resources/$1/$1_exception_temp.txt
  Resources/format_exception.sh $1 Resources/exception.csv >> Resources/$1/$1_exception_temp.txt

  echo "" > Resources/$1/$1_geoip_temp.txt
  echo "# GEOIP" >> Resources/$1/$1_geoip_temp.txt
  Resources/format_exception.sh $1 Resources/geoip.csv >> Resources/$1/$1_geoip_temp.txt

  echo "" >> Resources/$1/$1_geoip_temp.txt
}

format_zone () {
  echo "Formatting $2-aggregated.zone for $1 ..."

  grep -E '^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])' \
  $2-aggregated.zone > Resources/$1/$2_zone_temp.txt

  case $2 in
    jp ) echo "## Japan zone" > Resources/$1/$2_zone_$1_temp.txt
    ;;
    us ) echo "## USA zone" > Resources/$1/$2_zone_$1_temp.txt
    ;;
    kr ) echo "## Korea zone" > Resources/$1/$2_zone_$1_temp.txt
    ;;
    cn ) echo "## China zone" > Resources/$1/$2_zone_$1_temp.txt
    ;;
  esac

  if [[ $1 == ClashX ]]; then
    case $2 in
      jp ) awk 'NF {printf "- IP-CIDR,%s,Japan_Tokyo\n", $0 }' Resources/$1/$2_zone_temp.txt >> Resources/$1/$2_zone_$1_temp.txt
      ;;
      us ) awk 'NF {printf "- IP-CIDR,%s,USA_Oregon\n", $0 }' Resources/$1/$2_zone_temp.txt >> Resources/$1/$2_zone_$1_temp.txt
      ;;
      kr ) awk 'NF {printf "- IP-CIDR,%s,Korea_Seoul\n", $0 }' Resources/$1/$2_zone_temp.txt >> Resources/$1/$2_zone_$1_temp.txt
      ;;
      cn )  awk 'NF {printf "- IP-CIDR,%s,DIRECT\n", $0 }' Resources/$1/$2_zone_temp.txt >> Resources/$1/$2_zone_$1_temp.txt
      ;;
    esac

  elif [[ $1 = Quantumult ]]; then
    case $2 in
      jp ) awk 'NF {printf "IP-CIDR,%s,Japan_Tokyo\n", $0 }' Resources/$1/$2_zone_temp.txt >> Resources/$1/$2_zone_$1_temp.txt
      ;;
      us ) awk 'NF {printf "IP-CIDR,%s,USA_Oregon\n", $0 }' Resources/$1/$2_zone_temp.txt >> Resources/$1/$2_zone_$1_temp.txt
      ;;
      kr ) awk 'NF {printf "IP-CIDR,%s,Korea_Seoul\n", $0 }' Resources/$1/$2_zone_temp.txt >> Resources/$1/$2_zone_$1_temp.txt
      ;;
      cn ) awk 'NF {printf "IP-CIDR,%s,DIRECT\n", $0 }' Resources/$1/$2_zone_temp.txt >> Resources/$1/$2_zone_$1_temp.txt
      ;;
    esac

  elif [[ $1 = QuantumultX ]]; then
    case $2 in
      jp ) awk 'NF {printf "ip-cidr, %s, Japan_Tokyo\n", $0 }' Resources/$1/$2_zone_temp.txt >> Resources/$1/$2_zone_$1_temp.txt
      ;;
      us ) awk 'NF {printf "ip-cidr, %s, USA_Oregon\n", $0 }' Resources/$1/$2_zone_temp.txt >> Resources/$1/$2_zone_$1_temp.txt
      ;;
      kr ) awk 'NF {printf "ip-cidr, %s, Korea_Seoul\n", $0 }' Resources/$1/$2_zone_temp.txt >> Resources/$1/$2_zone_$1_temp.txt
      ;;
      cn ) awk 'NF {printf "ip-cidr, %s, direct\n", $0 }' Resources/$1/$2_zone_temp.txt >> Resources/$1/$2_zone_$1_temp.txt
      ;;
    esac
  fi

  echo "" >> Resources/$1/$2_zone_$1_temp.txt
}

gen_config () {
  echo "Generating configure file for $1 ..."

  case $1 in
    ClashX ) SUFFIX=yml
    ;;
    Quantumult ) SUFFIX=conf
    ;;
    QuantumultX ) SUFFIX=txt
    ;;
  esac

  cat Resources/$1/config_settings.$SUFFIX \
      Resources/$1/$1_exception_temp.txt \
      Resources/$1/$1_geoip_temp.txt \
      Resources/$1/jp_zone_$1_temp.txt \
      Resources/$1/us_zone_$1_temp.txt \
      Resources/$1/kr_zone_$1_temp.txt \
      Resources/$1/config_tail.$SUFFIX > $1.$SUFFIX
}

gen_main () {
  echo ""

  format_exception $1
  format_zone $1 jp
  format_zone $1 us
  format_zone $1 kr

  # format_zone $1 cn

  gen_config $1

  echo "Cleaning up ..."
  rm Resources/$1/*_temp.txt
}

gen_main ClashX
gen_main Quantumult
gen_main QuantumultX

echo ""
echo "Done !"
