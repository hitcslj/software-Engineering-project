<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    /*获取工程路径*/
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
    <script src="https://cdn.bootcss.com/jquery/2.1.1/jquery.min.js"></script>
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        //主界面高度自适应
        $(function () {
            //top代表顶层窗口对象
            top.mainHeight();
            if('${msg}'!=''){
                alert('${msg}');
            }
        });
        //查询事件
        function findData(){
            $('#currentPage').val('1');
            document.forms[0].submit();
        }
        //清空查询条件
        function clearP(){
            $("#name").val("");

        }

        //删除客户
        function del(id) {
            if(confirm("确定要删除该客户吗？")){
                $.ajax({
                    url:"<%=basePath%>customer/del",
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
        //编辑用户 先获取当前ID用户信息
        function edit(id) {
            $.ajax({
                url:"<%=basePath%>customer/selectCustomerById",
                type:"post",
                dataType:"json",
                data:{id:id},
                success:function (data) {
                    $("#editModal").modal("show");
                    $("#name2").val(data.name);
                    $("#telephone2").val(data.telephone);
                    $("#myid").val(data.id);
                },
                error:function () {
                    alert("获取用户数据失败！");
                }
            });
        }
    </script>
</head>
<body style="background-color: #d7f5e9">

<!-- 导航栏 -->
<div class="view">
    <nav class="navbar navbar-default" role="navigation">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand" href="<%=basePath%>user/selectAll">员工管理</a>
            </div>
            <div class="navbar-header">
                <a class="navbar-brand" href="#">客户管理</a>
            </div>
            <div class="navbar-header">
                <a class="navbar-brand" href="<%=basePath%>warehouse/selectAll">仓库管理</a>
            </div>

            <div class="navbar-header">
                <a class="navbar-brand" href="<%=basePath%>boss/selectTradeOrder">批发订单</a>
            </div>
            <ul class="nav navbar-nav navbar-right">
                <li><a class="navbar-brand" href="<%=basePath%>items/selectAll">商品列表</a></li>
            </ul>
        </div>
    </nav>
</div>

<div class="table-responsive">
    <form class="form-inline" role="form" action="<%=basePath%>customer/selectAll" method="post" id="myform">
        <div style="margin-left: 80px;">
            姓名：<input type="text" name="name" id="name" value="${customerInfo1.name}" class="form-control" style="width: 120px;">
            <input type="button" onclick="findData();" class="btn btn-info" value="查询"/>
            <input type="button" onclick="clearP();" class="btn btn-info" value="清空"/>
            <input type="button" data-toggle="modal" data-target="#addModal" class="btn btn-info" value="新增"/>
        </div>
        <hr style="margin-top: 10px;"/>
        <div style="margin-left: 20px;">
            <table class="table table-hover">
                <thead>
                <tr style="text-align: center">
                    <th style="text-align: center">序号</th>
                    <th style="text-align: center">姓名</th>
                    <th style="text-align: center">电话</th>
                    <th style="text-align: center">操作</th>
                </tr>
                </thead>
                <tbody>
                <c:if test="${!empty customerList }">
                    <c:forEach items="${customerList}" var="customer" varStatus="status">
                        <tr style="text-align: center">
                            <td>${customer.id}</td>
                            <td>${customer.name }</td>
                            <td>${customer.telephone }</td>
                            <td>
                                <button type="button" class="btn btn-success" onclick="edit('${customer.id }')">编辑</button>
                                <button type="button" class="btn btn-danger" onclick="del('${customer.id }')">删除</button>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
                </tbody>
            </table>
            <div >
                <jsp:include page="/common/page.jsp"/>
            </div>
        </div>
    </form>
</div>
<!-- 新增客户模态框（Modal） -->
<form action="<%=basePath%>customer/addCustomer" method="post" id="register_form1">
    <div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 id="mytitle" class="modal-title" id="myModalLabel">
                        新增客户
                    </h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <input class="form-control required" type="text" id="name1" placeholder="Name" name="name" autofocus="autofocus"/>
                    </div>
                    <div class="form-group">
                        <input class="form-control required" placeholder="telephone" id="telephone" name="telephone" autofocus="autofocus"/>
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
<!-- 编辑客户模态框（Modal） -->
<form action="<%=basePath%>customer/updateCustomer" method="post" id="editModalForm">
    <input type="hidden" id="myid" name="myid"/>
    <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 id="mytitle1" class="modal-title" id="myModalLabel1">
                        编辑客户
                    </h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <input class="form-control required" type="text" id="name2" placeholder="Name" name="name" autofocus="autofocus"/>
                    </div>
                    <div class="form-group">
                        <input class="form-control required" placeholder="telephone" id="telephone2" name="telephone" autofocus="autofocus"/>
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
</body>
</html>


