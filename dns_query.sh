#!/bin/bash

# 定义要查询的 DNS 服务器及其对应的名称
dns_servers=(
    "119.29.29.29 Tencent DNS 1"        # 腾讯
    "182.254.116.116 Tencent DNS 2"      # 腾讯
    "223.5.5.5 Ali DNS"                   # 阿里云
    "211.136.10.10 China Mobile DNS"      # 中国移动
    "202.96.128.86 China Telecom DNS"     # 中国电信
    "61.139.2.69 China Unicom DNS"        # 中国联通
    "8.8.8.8 Google DNS 1"                # Google
    "8.8.4.4 Google DNS 2"                # Google
    "1.1.1.1 Cloudflare DNS 1"            # Cloudflare
    "1.0.0.1 Cloudflare DNS 2"            # Cloudflare
    "208.67.222.222 OpenDNS 1"            # OpenDNS
    "208.67.220.220 OpenDNS 2"            # OpenDNS
)

# 提示用户输入要查询的域名
read -p "请输入要查询的域名: " domain

# 初始化输出变量
output=""

# 输出表头
printf "%-25s %-30s\n" "DNS 服务器" "解析结果"
printf "%-25s %-30s\n" "------------------------- " "------------------------------"

# 循环遍历每个 DNS 服务器并发送查询请求
for server_info in "${dns_servers[@]}"; do
    # 使用空格分割服务器和名称
    server=$(echo "$server_info" | awk '{print $1}')
    name=$(echo "$server_info" | awk '{$1=""; print substr($0,2)}')  # 去掉第一个字段并输出其余部分

    # 获取所有 IP 地址
    ip_addresses=$(dig @$server $domain +short)  # 只返回 IP 地址
    
    # 检查 IP 地址是否为空
    if [ -z "$ip_addresses" ]; then
        ip_addresses="No IP address found"
    fi

    # 将 IP 地址按行输出
    for ip in $ip_addresses; do
        printf "%-25s %-30s\n" "$name" "$ip"
        name=""  # 第一次输出后，清空名称以避免重复
    done
done
