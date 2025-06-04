#! /bin/bash

AT1="AT-1-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r"
AT2="AT-2-b38sDr3jDnMjph-SSEWqvCJJ6de5XE9s"
AT3="AT-3-z43sDr3jDnMjph-SSEWqvCJJ6de5XE9s"
AT4="AT-4-foo34ZEjDnMjph-SSEWqvCJJ6de5XE9s"
AT=$AT4
#https://avenirs-apache/cas/oidc/profile?token=AT-14-NF-qT-NwVKXVA5cyxaeLnaxtYIA4bkkX


 #curl -X POST "http://localhost/avenirs-portfolio-security/oidc/profile"      -H "x-authorization: AT-14-NF-qT-NwVKXVA5cyxaeLnaxtYIA4bkkX"      -H "Accept: application/json"
 curl -k  --header "Authorization: Bearer $AT"  -X GET "https://localhost/apim/me/navigation-access"      -H "Accept: application/json"

