# 安装

https://golang.google.cn/

# 配置

- 环境变量

```shell
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
```

- 依赖拉取

```shell
go get -u -v github.com/nsf/gocode
go get -u -v github.com/rogpeppe/godef
go get -u -v github.com/golang/lint/golint
go get -u -v github.com/lukehoban/go-find-references
go get -u -v github.com/lukehoban/go-outline
go get -u -v sourcegraph.com/sqs/goreturns
go get -u -v golang.org/x/tools/cmd/gorename
go get -u -v github.com/tpng/gopkgs
go get -u -v github.com/newhook/go-symbols
```

# 问题
vscode调试go报错

- lldb-server

```shell
 debugserver or lldb-server not found: install XCode's command line tools or lldb-server
```

- 重新在终端安装下xcode-select

```shell
xcode-select --install
```



参考：[Go安装&VSCode调试](https://www.jianshu.com/p/e28f7690a598)

