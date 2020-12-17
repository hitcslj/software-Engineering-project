
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    /*获取工程路径*/
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>
        商品页
    </title>
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js">
    </script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js">
    </script>
    <script type="text/javascript">
        //查询事件
        function findData(){
            $('#currentPage').val('1');
            document.forms[0].submit();
        }
        //清空查询条件
        function clearP(){
            $("#name").val("");
        }

        $(function() {
            $('#addorder').on('show.bs.modal',
                function() {
                    var iteminputname = new Array();
                    var itemnames = new Array();
                    var itemprices = new Array();
                    var iteminprices = new Array();
                    var itemid = new Array();
                    <c:forEach items="${itemsList}" var="items">
                      iteminputname.push('${items.id.toString().concat('input')}');//标签名压一个数组
                      itemnames.push('${items.name}');//商品名压一个数组
                      if(document.getElementById("switchrewh").value=='零售')itemprices.push('${items.price}');//商品价格压一个数组
                      else itemprices.push('${items.tradeprice}');
                      iteminprices.push('${items.inprice}');//进价也压一个
                      itemid.push('${items.id}')
                    </c:forEach>
                    var table = document.getElementById('order');//这里获取表单
                    var itemname = "";
                    var itemnumber="";
                    var itemprice = "";
                    var sumprice = 0;
                    var suminprice = 0;
                    table.innerHTML = "";//表单删除之前内容
                    for (var counter =0 ;counter<iteminputname.length;counter++)
                    {
                        var input = document.getElementById(iteminputname[counter]);//获取各个输入
                        if(input.value!=0)//不为0，准备新建标签压表单
                        {
                            var p  = document.createElement('tr');
                            if(counter%2==0)p.setAttribute('class','alt');
                            var p1 = document.createElement('td');
                            var p2 = document.createElement('td');
                            var p3 = document.createElement('td');
                            p1.innerText = itemnames[counter];
                            p2.innerText = input.value;
                            sumprice+=Number(itemprices[counter])*Number(input.value);
                            suminprice+=Number(iteminprices[counter])*Number(input.value);
                            p3.innerText = "价格：" + String(Number(itemprices[counter])*Number(input.value));
                            p.appendChild(p1);
                            p.appendChild(p2);
                            p.appendChild(p3);
                            table.appendChild(p);
                            itemname+=itemnames[counter] + " ";//这里得传id
                            itemnumber+=input.value + " ";
                            itemprice = itemprice+' '+itemprices[counter];
                        }
                    }
                    var p4 = document.createElement('tr');
                    p4.innerText = "总计："+ String(sumprice);
                    table.appendChild(p4);
                    document.getElementsByName('itemsName')[0].value =itemname;
                    document.getElementsByName('itemsNumber')[0].value =itemnumber;
                    document.getElementsByName('itemsPrice')[0].value = itemprice;
                    document.getElementsByName('totalPrice')[0].value = String(sumprice);
                    document.getElementsByName('inPrice')[0].value = String(suminprice);
                    if(document.getElementById("switchrewh").value=='零售')
                    {
                        document.getElementsByName('type')[0].value = 'retail';
                        document.getElementsByName('state')[0].value = 'ok';
                    }
                    else
                    {document.getElementsByName('type')[0].value = 'trade';
                     document.getElementsByName('state')[0].value = '待分配';
                    }
                })
        });
        //删除商品
        function del(id) {
            if(confirm("确定要删除该商品吗？")){
                $.ajax({
                    url:"<%=basePath%>items/del",
                    type:"post",
                    dataType:"json",
                    data:{id:id},
                    success:function () {
                        alert("删除成功！");
                        $("#myform").submit();
                    },
                    error:function () {//不知道为什么有时会走error
                        alert("删除失败！");
                        $("#myform").submit();
                    }
                });
            }
        }
        //编辑 先获取当前ID商品信息
        function edit(id) {
            $.ajax({
                url:"<%=basePath%>items/selectItemsById",
                type:"post",
                dataType:"json",
                data:{id:id},
                success:function (data) {
                    $("#editModal").modal("show");
                    $("#name2").val(data.name);
                    $("#myid").val(data.id);
                    $("#price2").val(data.price);
                    $("#number2").val(data.number);
                },
                error:function () {
                    alert("获取失败！");
                }
            });
        }
        function loginOut(obj){
            if (confirm('您确定要退出系统吗？')) {
                if(self!=top){
                    top.location.href="<%=basePath%>user/loginOut";
                    return;
                }
                obj.href = "<%=basePath%>user/loginOut";
                obj.onclick = "";
                obj.click();
            }
        }
        function Switchretailandwholesale() {
            var iteminputname = new Array();
            var itemprice = new Array();
            var itemtradeprice = new Array();
            <c:forEach items="${itemsList}" var="items">
            iteminputname.push('${items.id.toString().concat('price')}');//标签名压一个数
            itemprice.push('${items.price}');//标签名压一个数
            itemtradeprice.push('${items.tradeprice}');//标签名压一个数
            </c:forEach>

            for (var counter = 0;counter<iteminputname.length;counter++)
            {
                if(document.getElementById("switchrewh").value=='零售')
                {

                    document.getElementById(iteminputname[counter]).innerText=itemprice[counter];
                }
                else  document.getElementById(iteminputname[counter]).innerText=itemtradeprice[counter];
            }

        }
    </script>

</head>
<body style="background-color: #d7f5e9">
<div style="background-color:#ffff00; padding-top:5px;">
    <b style="font-size:30px;">竹林百货</b>
    <br>
    <b>zhulinbaihuo.com</b>
    <a style="position: absolute;top: 5px;right: 10px" href="#" onclick="loginOut(this)">退出系统</a>
</div>
<!-- 导航栏 -->
<div class="view">
    <nav class="navbar navbar-default" role="navigation">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand active" href="#">商品列表</a>
            </div>
            <div class="navbar-header">
                <a class="navbar-brand" href="<%=basePath%>order/selectAll">订单列表</a>
            </div>
            <ul class="nav navbar-nav navbar-right">
                <form role="form">
                    <div class="form-group">
                        <select class="form-control" id = 'switchrewh'onchange="Switchretailandwholesale()">
                            <option>零售</option>
                            <option>批发</option>
                        </select>
                    </div>
                </form>
            </ul>
        </div>
    </nav>
</div>

<!-- 加减按钮 -->
<script>
    function subNum(name){
        if(document.getElementById(name).value<=0){document.getElementById(name).value=0;}else{
            document.getElementById(name).value=document.getElementById(name).value-1;}
    }
    function addNum(name){
        document.getElementById(name).value=document.getElementById(name).value-(-1);
    }
</script>

<div class="table-responsive">
    <form class="form-inline" role="form" action="<%=basePath%>items/selectAll" method="post" id="myform">
        <div style="margin-left: 80px;">
            商品名称：<input type="text" name="name" id="name" value="${itemsInfo1.name}" class="form-control" style="width: 120px;">
            <input type="button" onclick="findData();" class="btn btn-info" value="查询"/>
            <input type="button" onclick="clearP();" class="btn btn-info" value="清空"/>
            <input type="button" data-toggle="modal" data-target="#addModal" class="btn btn-info" value="新增"/>
        </div>
        <hr style="margin-top: 10px;"/>
        <div style="margin-left: 20px;">
            <table class="table table-hover">
                <thead>
                <tr style="text-align: center" class="success">
<%--                    <th style="text-align: center">操作</th>--%>
                    <th style="text-align: center">商品名称</th>
                    <th style="text-align: center">价格</th>
                    <th style="text-align: center">当前库存</th>
                    <th style="text-align: center">买</th>
                </tr>
                </thead>
                <tbody>
                <c:if test="${!empty itemsList }">
                    <c:forEach items="${itemsList}" var="items" varStatus="status">
                        <tr style="text-align: center">
<%--                            <td>--%>
<%--                                <button type="button" class="btn btn-success" onclick="edit('${items.id }')">编辑</button>--%>
<%--                                <button type="button" class="btn btn-danger" onclick="del('${items.id }')">删除</button>--%>
<%--                            </td>--%>
                            <td>${items.name }</td>
                            <td id = '${items.id.toString().concat("price")}'>${items.price}</td>
                            <td>${items.number}</td>
                            <td><div class="row">
                                <div class="col-lg-3">
                                    <div class="input-group">
                                    <span class="input-group-btn">
                                        <button class="btn btn-default" type="button" onclick="subNum('${items.id.toString().concat("input")}')">-</button>
                                    </span>
                                    <input type="text" id='${items.id.toString().concat("input")}' class="form-control" placeholder="0">
                                    <span class="input-group-btn">
                                        <button class="btn btn-default" type="button" onclick="addNum('${items.id.toString().concat("input")}')">+</button>
                                    </span>
                                    </div>
                                </div>
                            </div></td>
                        </tr>
                    </c:forEach>
                </c:if>
                </tbody>
            </table>
            <%--<div >
                <jsp:include page="/common/page.jsp"/>
            </div>--%>
        </div>
    </form>
</div>

<!-- 新增模态框（Modal） -->
<form action="<%=basePath%>items/addItems" method="post" id="register_form1">
    <div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    </button>
                    <h4 id="mytitle" class="modal-title" id="myModalLabel">
                        新增商品
                    </h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <input class="form-control required" type="text" id="name1" placeholder="Name" name="name" autofocus="autofocus"/>
                    </div>
                    <div class="form-group">
                        <input class="form-control required" type="text" placeholder="Price" id="price1" name="price" autofocus="autofocus"/>
                    </div>
                    <div class="form-group">
                        <input class="form-control required" type ="text" placeholder="Number" id="number1" name="number"/>
                    </div>
                    <div class="form-group">
                        <input class="form-control required" type ="text" placeholder="Inprice" id="inprice1" name="inprice"/>
                    </div>
                    <div class="form-group">
                        <input class="form-control required" type ="text" placeholder="Tradeprice" id="tradeprice1" name="tradeprice"/>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                    </button>
                    <button type="submit" class="btn btn-info">
                        确认
                    </button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal -->
    </div>
</form>
<!-- 编辑商品模态框（Modal） -->
<form action="<%=basePath%>items/updateItems" method="post" id="editModalForm">
    <input type="hidden" id="myid" name="myid"/>
    <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 id="mytitle1" class="modal-title" id="myModalLabel1">
                        编辑商品
                    </h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <input class="form-control required" type="text" id="name2" placeholder="Name" name="name" autofocus="autofocus"/>
                    </div>
                    <div class="form-group">
                        <input class="form-control required" type="text" placeholder="Price" id="price2" name="price" autofocus="autofocus"/>
                    </div>
                    <div class="form-group">
                        <input class="form-control required" type="text" placeholder="Number" id="number2" name="number" autofocus="autofocus"/>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                    </button>
                    <button type="submit" class="btn btn-info">
                        确认修改
                    </button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal -->
    </div>
</form>

<!-- 订单模态框（Modal） -->

<center><button class="btn btn-primary btn-lg" data-toggle="modal" data-target="#addorder">
        提交
</button></center>

<form action="<%=basePath%>order/addOrder" method="get" id="OrderForm">
    <div class="modal fade" id="addorder" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title" id="myOrderLabel">
                        订单
                    </h4>
                </div>
                <div class="modal-body">
                    <table id="order">
                    </table>
                </div>
                <div class="modal-footer">
                    <input type="hidden" name="itemsName" value=""/>
                    <input type="hidden" name="itemsNumber" value=""/>
                    <input type="hidden" name="itemsPrice" value=""/>
                    <input type="hidden" name="totalPrice" value=""/>
                    <input type="hidden" name="inPrice" value=""/>
                    <input type="hidden" name="state" value="ok"/>
                    <input type="hidden" name="type" value=""/>
                    <input type="text" name="telephone" value="telephone"/>
                    <input type="text" name="customerName" value="customerName"/>
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                    </button>
                    <button type="submit" class="btn btn-primary">
                        确认
                    </button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal -->
    </div>
</form>
<!-- 订单样式 -->
<style type="text/css">
    #order {
        font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
        width: 100%;
        border-collapse: collapse;
    }
    #order td,
    #order th {
        font-size: 1em;
        border: 1px solid #98bf21;
        padding: 3px 7px 2px 7px;
    }
    #order th {
        font-size: 1.1em;
        text-align: left;
        padding-top: 5px;
        padding-bottom: 4px;
        background-color: #A7C942;
        color: #ffffff;
    }
    #order tr.alt td {
        color: #000000;
        background-color: #EAF2D3;
    }
</style>

</body>
</html>
