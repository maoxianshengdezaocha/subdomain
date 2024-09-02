#!/bin/bash
# 创建一个工作的主要函数,需要输入网址
main() {
        # 获取函数输入的url
        local url=$1;
        # 下载网页
        curl $url -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:129.0) Gecko/20100101 Firefox/129.0' -o index.html;
        echo "[+]访问网页成功!";
        # 提取网页中所有的域名
        echo '' > domain.txt;
        grep -o -E '/[a-zA-Z0-9\.]*\.[a-zA-Z0-9]*\.[a-zA-Z0-9]*' index.html|sed 's/\///'|sort -ru >> domain.txt;
        echo "[+]提取域名成功!"
        # 将域名转换为IP
        rm -f info.txt
        #提取主机名
        local TargetHost=$(echo $url|cut -d '/' -f 3 >> domain.txt);
        for domain in $(cat domain.txt); do (echo $domain;host $domain|sed 's/IPv6 //'|grep "address"|awk -F " " '{print $1" "$4}' >> temp.txt); done;
        sort -u temp.txt >> info.txt
        echo "[+]转换IP成功!";
        # 删除临时文件
        rm -r temp.txt
        rm -f index.html
        rm -f domain.txt;
        echo "[+]清理垃圾文件成功!"
        # 读取结果文件
        cat info.txt;
}
# 判断是否输入域名
if [  -n "$1" ];then
        main $1;
else
        echo 'Usage: subdomain.sh https://www.baidu.com';
fi;