#!/bin/sh

# 定义更新函数
update_pac() {
  echo "[$(date)] 更新 proxy.pac …"
  genpac --format=pac \
          --pac-proxy="SOCKS5 ${LOCAL_IP}:7890; SOCKS ${LOCAL_IP}:7890; DIRECT;" \
          --gfwlist-local="/pac/gfwlist.txt" \
          --output="/pac/proxy.pac"
}

# 1. 首次生成
update_pac

# 2. 启动 HTTP 服务（后台）
cd /pac
python3 -m http.server 80 &

# 3. 定时更新：每 UPDATE_INTERVAL 秒执行一次
#    默认 86400 秒（24h）
while true; do
  sleep 86400
  update_pac
done