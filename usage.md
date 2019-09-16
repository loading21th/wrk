#### 测试不同query
1. 查看args.lua ,设置不同的query
2. 查看scripts/ly_test.lua ,wrk.format设置不同的参数
```
./wrk -c 24 -t 12 -d 60 -s ./scripts/ly_setup.lua http://127.0.0.1:8002
```
