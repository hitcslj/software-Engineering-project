<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    /*获取工程路径*/
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单管理页</title>
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
        //删除订单
        function del(id) {
            if(confirm("确定要删除该订单吗？")){
                $.ajax({
                    url:"<%=basePath%>order/del",
                    type:"post",
                    dataType:"json",
                    data:{id:id},
                    success:function () {
                        alert("删除成功！");
                        $("#myform").submit();
                    },
                    error:function () {//不知道为什么有时会走error
                        alert("删除成功！");
                        $("#myform").submit();
                    }
                });
            }
        }
        //编辑 先获取当前ID信息
        function edit(id) {
            $.ajax({
                url:"<%=basePath%>order/selectOrderById",
                type:"post",
                dataType:"json",
                data:{id:id},
                success:function (data) {
                    $("#editModal").modal("show");
                    $("#customername").val(data.customerName);
                    $("#myid").val(data.id);
                    $("#telephone").val(data.telephone);
                },
                error:function () {
                    alert("获取失败！");
                }
            });
        }
        function Detail(id) {
            $.ajax({
                url:"<%=basePath%>order/selectOrderById",
                type:"post",
                dataType:"json",
                data:{id:id},
                success:function (data) {
                    $("#details").modal("show");

                    $("#itemsname").val(data.itemsName);
                    $("#itemsnumber").val(data.itemsNumber);
                    $("#itemsprice").val(data.itemsPrice);
                    $("#itemsprofit").val(data.totalPrice-data.inPrice);
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
                }
                obj.href = "<%=basePath%>user/loginOut";
                obj.onclick = "";
                obj.click();
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
                <a class="navbar-brand" href="<%=basePath%>items/selectAll">商品列表</a>
            </div>
            <div class="navbar-header">
                <a class="navbar-brand" href="#">订单列表</a>
            </div>

        </div>
    </nav>
</div>

<div class="table-responsive">
    <form class="form-inline" role="form" action="<%=basePath%>order/selectAll" method="post" id="myform">
        <div style="margin-left: 80px;">
            客户名：<input type="text" name="customerName" id="name" value="${orderInfo1.customerName}" class="form-control" style="width: 120px;">
            <input type="button" onclick="findData();" class="btn btn-info" value="查询"/>
            <input type="button" onclick="clearP();" class="btn btn-info" value="清空"/>
        </div>
        <hr style="margin-top: 10px;"/>
        <div style="margin-left: 20px;">
            <table class="table table-hover">
                <thead>
                <tr style="text-align: center" class="success">
                    <th style="text-align: center">操作</th>
                    <th style="text-align: center">订单号</th>
                    <th style="text-align: center">客户名</th>
                    <th style="text-align: center">电话号</th>
                    <th style="text-align: center">总价</th>
                    <th style="text-align: center">状态</th>
                </tr>
                </thead>
                <tbody>
                <c:if test="${!empty orderList }">
                    <c:forEach items = "${orderList}" var="order" varStatus="status">
                        <tr style="text-align: center">
                            <td>
                                <button type="button" class="btn btn-info" onclick="edit('${order.id }')">编辑</button>
                                <button type="button" class="btn btn-danger" onclick="del('${order.id }')">退单</button>
                            </td>
                            <td>${order.id }</td>
                            <td>${order.customerName }</td>
                            <td>${order.telephone }</td>
                            <td>${order.totalPrice}</td>
                            <td>${order.state}</td>
                            <td>
                                <button type="button" class="btn btn-primary" onclick="Detail('${order.id }')">详情</button>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
                </tbody>
            </table>
    <%--        <table class="table table-hover">
                <thead>
                <tr style="text-align: center" class="success">
                    <th style="text-align: center">总收入</th>
                    <th style="text-align: center">
                        /
                    </th>
                </tr>
                </thead>
            </table>
            <%--<div >
                <jsp:include page="/common/page.jsp"/>
            </div>--%>
        </div>
    </form>
</div>

<!-- 编辑订单模态框（Modal） -->
<form action="<%=basePath%>order/updateOrder" method="get" id="editModalForm">
    <input type="hidden" id="myid" name="id"/>
    <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 id="mytitle1" class="modal-title" id="myModalLabel1">
                        编辑订单
                    </h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <input class="form-control required" type="text" id="customername" placeholder="customerName" name="customerName" autofocus="autofocus"/>
                    </div>
                    <div class="form-group">
                        <input class="form-control required" type="text" placeholder="telephone" id="telephone" name="telephone" autofocus="autofocus"/>
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

<!-- 详情模态框（Modal） -->
<div class="modal fade" id="details" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title">
                    订单详情
                </h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <div class="col-sm-10">
                        商品名称：<input class="form-control" id="itemsname" type="text" placeholder="itemsName" disabled>
                        购买数量：<input class="form-control" id="itemsnumber" type="text" placeholder="itemsNumber" disabled>
                        单价：<input class="form-control" id="itemsprice" type="text" placeholder="itemsPrice" disabled>
                        利润：<input class="form-control" id="itemsprofit" type="text" placeholder="itemsPrice" disabled>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>

            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>

</body>
</html>
