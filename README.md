# 代理规则生成器 / autogen_proxy_rules

> 自动生成多款代理软件规则的一组shell脚本 / a bunch of shell scripts that can auto generate rules for multi-kind proxy tools

## 工具特色

+ 以纯*shell*以及*awk*和*sed*实现，让所有人都看得懂，进而可以自行修改

+ 可以自动从[*ipdeny*](http://www.ipdeny.com)下载最新的国家IP段，并利用其生成规则

+ 一键生成*多款*代理软件的配置文件（含规则）

  - 目前支持的代理软件有：[Clash](https://github.com/Dreamacro/clash) / [ClashX](https://github.com/yichengchen/clashX)、[Quantumult](https://github.com/crossutility/Quantumult) / [Quantumult X](https://github.com/crossutility/Quantumult-X)

## 工具缺点

+ 根据手头有的线路下载对应的国家IP段文件，所以有可能造成配置文件非常大的情况

+ 不够智能，部分功能被写死

## 如何使用

1. 先到`Resources`按照自己的实际情，况修改各个代理软件的`config_settings.xxx`文件，如加入代理服务器等

2. 然后将例外规则加入`Resources/exception.csv`

  + 需要注意的是，目前*Clash* / *ClashX*仍未支持`USER-AGENT`过滤器，<br/>所以`USER-AGENT`仅对**Quantumult** / **Quantumult X**生效

  + `Resources/exception.csv`并非标准格式的csv，其分隔符为`, `（一个英文逗号 + 一个英文空格）

  + `Resources/exception.csv`的`group`和`comment`**不会**对生成的规则文件产生任何影响，仅作例外文件规则辨识及标注用

  + `Resources/exception.csv`的格式化脚本是`Resources/format_exception.sh`

3. 回到项目根目录运行`./Generate_Rules.sh`即可

  + 第一次运行后，会多出几个`xx-aggregated.zone`文件，这就是从[*ipdeny*](http://www.ipdeny.com)下载最新的国家IP段，这几个文件将会被*awk*清洗和格式化，且下次运行脚本时会用*wget*增量下载文件更新，所以*无需*手动更改或删除

  + `ClashX.yml`对*Clash* / *ClashX*都有效，可直接通用

  + *Quantumult* / *Quantumult X*配置不通用，取所需即可

  + 以上并非实现项目功能的核心文件，已加入`.gitignore`

## 格式化脚本说明

格式化IP段文件的脚本为`Generate_Rules.sh`

+ 因为IP段文件偶尔会出现一些错误的IP段表达，这回导致ClashX崩溃，所以需要用正侧表达式进行过滤<br/>在脚本[第32行](/Generate_Rules.sh#L32)

+ 从[第46行](/Generate_Rules.sh#L46)开始，根据不同的国家IP段安排不同的线路，请根据实际需要修改

+ 如果你只有一条线路，推荐将脚本改成下载中国的IP段，然后将其全部指向`DIRECT`；并将`Final`指向你的线路标签<br/>而不是像项目这样分开好几个国家安排线路，这样就可以有效地减少生成文件的体积

## 其他说明

+ 目前本项以*为个人使用*为目的，所以某些功能上的设计可能比较死板，欢迎各位大佬前来完善和拓展其功能🙏

+ 目前项目有三个线路标记，即`Japan_Tokyo / USA_Oregon / Korea_Seoul`<br/><del>（因为本人有三条线路，这是方便自己使用的设计）</del>

+ *Quantumult*设置了一个延时策略，名为`ChatLatency`

+ *Quantumult X*设置了一个可用性策略，名为`Available_KUJ`

+ *Clash*设置了一个延时策略，名为`Chat_Group`

+ 以上请根据自身需要修改
