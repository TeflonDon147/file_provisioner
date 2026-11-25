
#!/bin/bash

set -e

echo "======================================"
echo "Starting ELK Stack Installation"
echo "======================================"

# 1. Update Ubuntu
sudo apt-get update -y
sudo apt-get upgrade -y

# 2. Install required packages
sudo apt-get install -y wget curl gnupg apt-transport-https

# 3. Import Elastic GPG signing key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch \
  | sudo gpg --dearmor --yes \
  -o /usr/share/keyrings/elasticsearch-keyring.gpg

# 4. Configure Elastic 7.x repository
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" \
  | sudo tee /etc/apt/sources.list.d/elastic-7.x.list

# 5. Update package repositories
sudo apt-get update -y

# 6. Install ELK components
sudo apt-get install -y \
  elasticsearch \
  logstash \
  kibana \
  metricbeat

echo "ELK packages installed successfully"

# 7. Create Logstash configuration directory
sudo mkdir -p /etc/logstash/conf.d

# 8. Install Elasticsearch configuration
sudo mv /tmp/elasticsearch.yml \
  /etc/elasticsearch/elasticsearch.yml

# 9. Install Kibana configuration
sudo mv /tmp/kibana.yml \
  /etc/kibana/kibana.yml

# 10. Install Apache Logstash pipeline
sudo mv /tmp/apache-01.conf \
  /etc/logstash/conf.d/apache-01.conf

# 11. Start Elasticsearch
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

# 12. Wait for Elasticsearch to become available
echo "Waiting for Elasticsearch..."

for i in {1..30}; do
  if curl -fsS http://localhost:9200 >/dev/null; then
    echo "Elasticsearch is ready"
    break
  fi

  if [ "$i" -eq 30 ]; then
    echo "Elasticsearch failed to become ready"
    sudo journalctl -u elasticsearch -n 50 --no-pager
    exit 1
  fi

  sleep 5
done

# 13. Start Kibana
sudo systemctl enable kibana
sudo systemctl start kibana

# 14. Start Metricbeat
sudo systemctl enable metricbeat
sudo systemctl start metricbeat

# 15. Validate Logstash configuration
sudo /usr/share/logstash/bin/logstash \
  --path.settings /etc/logstash -t

# 16. Start Logstash
sudo systemctl enable logstash
sudo systemctl start logstash

echo "======================================"
echo "ELK Stack Installation Completed"
echo "======================================"

# 17. Display service status
sudo systemctl status elasticsearch --no-pager
sudo systemctl status kibana --no-pager
sudo systemctl status metricbeat --no-pager
sudo systemctl status logstash --no-pager
