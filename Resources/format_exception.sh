#!/usr/bin/env bash

PROGRAM=$1

awk -F', ' '
  function head (soft, keyword) {
    if (soft == "ClashX") {
      switch (keyword) {
        case "HOST":
          rule_head = "- DOMAIN";
          break;
        case "KEYWORD":
          rule_head = "- DOMAIN-KEYWORD";
          break;
        case "SUFFIX":
          rule_head = "- DOMAIN-SUFFIX";
          break;
        case "IP-CIDR":
          rule_head = "- IP-CIDR";
          break;
        case "GEOIP":
          rule_head = "- GEOIP"
          break;
        case "AGENT":
          next;
      }
    } else
    if (soft == "Quantumult") {
      switch (keyword) {
        case "HOST":
          rule_head = "HOST";
          break;
        case "KEYWORD":
          rule_head = "HOST-KEYWORD";
          break;
        case "SUFFIX":
          rule_head = "HOST-SUFFIX";
          break;
        case "IP-CIDR":
          rule_head = "IP-CIDR";
          break;
        case "GEOIP":
          rule_head = "GEOIP";
          break;
        case "AGENT":
          rule_head = "USER-AGENT";
          break;
      }
    } else
    if (soft == "QuantumultX") {
      switch (keyword) {
        case "HOST":
          rule_head = "host";
          break;
        case "KEYWORD":
          rule_head = "host-keyword";
          break;
        case "SUFFIX":
          rule_head = "host-suffix";
          break;
        case "IP-CIDR":
          rule_head = "ip-cidr";
          break;
        case "GEOIP":
          rule_head = "geoip";
          break;
        case "AGENT":
          rule_head = "user-agent";
          break;
      }
    }
    return rule_head;
  }

  function tail (soft, keyword) {
    if (soft == "ClashX") {
      switch (keyword) {
        case "REJECT":
          rule_tail = "REJECT";
          break;
        case "DIRECT":
          rule_tail = "DIRECT";
          break;
        case "AUTO":
          rule_tail = "Chat_Group";
          break;
        case "jp_proxy":
          rule_tail = "Japan_Tokyo";
          break;
        case "us_proxy":
          rule_tail = "USA_Oregon";
          break;
        case "kr_proxy":
          rule_tail = "Korea_Seoul";
          break;

      }
    } else
    if (soft == "Quantumult") {
      switch (keyword) {
        case "REJECT":
          rule_tail = "REJECT";
          break;
        case "DIRECT":
          rule_tail = "DIRECT,no-resolve";
          break;
        case "AUTO":
          rule_tail = "ChatLatency"
          break;
        case "jp_proxy":
          rule_tail = "Japan_Tokyo";
          break;
        case "us_proxy":
          rule_tail = "USA_Oregon";
          break;
        case "kr_proxy":
          rule_tail = "Korea_Seoul";
          break;
      }
    } else
    if (soft == "QuantumultX") {
      switch (keyword) {
        case "REJECT":
          rule_tail = "reject";
          break;
        case "DIRECT":
          rule_tail = "direct";
          break;
        case "AUTO":
          rule_tail = "Available_KUJ"
          break;
        case "jp_proxy":
          rule_tail = "Japan_Tokyo";
          break;
        case "us_proxy":
          rule_tail = "USA_Oregon";
          break;
        case "kr_proxy":
          rule_tail = "Korea_Seoul";
          break;
      }
    }
    return rule_tail;
  }

  {
    if (NR>2) {
      printf "%s,%s,%s\n", head("'$PROGRAM'", $2), $3 ,tail("'$PROGRAM'", $4);
    }
  }
' $2
