### 运行步骤

第一步: 新建文件夹，进入后 truffle unbox webpack <br>
第二步: 替换文件: migrations/2_deploy_contracts.js, truffle.js, 整个app目录，然后把ShareD.sol加入contracts目录 <br>
第三步: 运行ganache，记录下账号和私钥，后面方便Metamask使用 <br>
第四步: (新开terminal) truffle migrate --network ganache <br>
第五步: truffle console --network ganache <br>
第六步: (在truffle console里注册一些作者) <br>
ShareD.deployed().then(function(instance) { instance.registerAsAuthor('Chris', 'chris@ucsc.edu');}) <br>
ShareD.deployed().then(function(instance) { instance.registerAsAuthor('Palm', 'palm@ucsc.edu');}) <br>
第七步: (在truffle console里添加一些文章) <br>
ShareD.deployed().then(function(i) { i.publishArticle(1543260000, 'Big Pig Review', 'This is a review of the movie Big Pig', 'QmV83gJxZunzJxEYDUmqG5qojpD4TK5RvTV86AQsaA3xXA', 0);}) <br>
ShareD.deployed().then(function(i) { i.publishArticle(1543200000, 'Lion King Review', 'This is a review of the movie Lion King', 'QmV83gJxZunzJxEYDUmqG5qojpD4TK5RvTV86AQsaA3xXA', 1);}) <br>
ShareD.deployed().then(function(i) { i.publishArticle(1543100000, 'Small Pig Review', 'This is a review of the movie Small Pig', 'QmV83gJxZunzJxEYDUmqG5qojpD4TK5RvTV86AQsaA3xXA', 1);}) <br>
第八步: 从浏览器前端进入对接测试: 新开窗口，输入 npm run dev, compiled之后进入localhost:8080 <br>
第九步: 从浏览器的console，可以看到 index.js 文件里的函数调用结果 <br>


### 主要对接文件
app/scrips/index.js





