{# indents are necessary for ec2 template rendering #}
{%- set s3bucket = "ars-pugnandi-haproxy-configuration-eu-central-1" %}
                  #!/bin/bash
                  echo "$(date) : copy new haproxy.cfg"
                  aws --region eu-central-1 s3 cp s3://{{s3bucket}}/haproxy.cfg /opt/haproxy.cfg
                  echo "$(date) : reload haproxy"
                  sudo docker kill -s HUP haproxy
