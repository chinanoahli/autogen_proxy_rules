# 格式化脚本说明

格式化例外规则脚本为`format_exception.sh`

例外规则列表为`exception.csv`，其非标准格式的csv，其分隔符为`, `（一个英文逗号 + 一个英文空格）

本质上调用的是`awk`格式化例外规则列表文件`exception.csv`

其中[`head`函数](/Resources/format_exception.sh#L6)为规则自动识别并加上因不同代理软件而不同的**规则类别**

其中[`tail`函数](/Resources/format_exception.sh#L75)为规则自动识别并加上因不同代理软件而不同的**动作标记**
