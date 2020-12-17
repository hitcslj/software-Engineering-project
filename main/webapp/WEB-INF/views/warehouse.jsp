
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
        仓库管理页面
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

        //调度商品 先获取当前ID商品信息
        function dispatch(id) {
            $.ajax({
                url:"<%=basePath%>items/selectItemsById",
                type:"post",
                dataType:"json",
                data:{id:id},
                success:function (data) {
                    $("#dispatchModal").modal("show");
                    $("#name2").val(data.name);
                    $("#myid").val(data.id);
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
                }//这逻辑做的太乱了，为什么老板要嵌套？员工不要嵌套？
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
                <a class="navbar-brand active" href="#">仓库</a>
            </div>
            <div class="navbar-header">
                <a class="navbar-brand" href="<%=basePath%>warehouse/selectOrderByState">批发单</a>
            </div>
        </div>
    </nav>
</div>

</div>
<div class="table-responsive">
    <form class="form-inline" role="form" action="<%=basePath%>warehouse/selectAll" method="post" id="myform">
        <div style="margin-left: 80px;">
            商品名称：<input type="text" name="name" id="name" value="${itemsInfo1.name}" class="form-control" style="width: 120px;">
            <input type="button" onclick="findData();" class="btn btn-info" value="查询"/>
            <input type="button" onclick="clearP();" class="btn btn-info" value="清空"/>
            <input type="button" data-toggle="modal" data-target="#addModal" class="btn btn-info" value="进货"/>
            <div class="dropdown">
                <button type="button" class="btn dropdown-toggle" id="warehouse_dropdownMenu1"
                        data-toggle="dropdown">
                    选择仓库
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" role="menu" aria-labelledby="warehouse_dropdownMenu1">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="<%=basePath%>/warehouse/selectAll">全部</a>
                    </li>
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="<%=basePath%>/warehouse/selectWarehouse?warehouse=Z">门店(Z)</a>
                    </li>
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="<%=basePath%>/warehouse/selectWarehouse?warehouse=A">仓库A</a>
                    </li>
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="<%=basePath%>/warehouse/selectWarehouse?warehouse=B">仓库B</a>
                    </li>
                </ul>
            </div>
        </div>
        <hr style="margin-top: 10px;"/>
        <div style="margin-left: 20px;">
            <table class="table table-hover">
                <thead>
                <tr style="text-align: center" class="success">
                    <th style="text-align: center">操作</th>
                    <th style="text-align: center">商品名称</th>
                    <th style="text-align: center">仓库位置</th>
                    <th style="text-align: center">当前仓库库存</th>
                    <th style="text-align: center">总库存</th>
                </tr>
                </thead>
                <tbody>
                <c:if test="${!empty itemsList }">
                    <c:forEach items="${itemsList}" var="items" varStatus="status">
                        <tr style="text-align: center">
                            <td>
                                <c:if test='${!(userInfo.identity.equals("boss"))}'>
                                <button type="button" class="btn btn-success" onclick="dispatch('${items.id }')">调度</button>
                                </c:if>
                            </td>
                            <td>${items.name }</td>
                            <td>${items.location }</td>
                            <td>${items.number}</td>
                            <td>${Numberofnames.get(items.name)}</td>
                        </tr>
                    </c:forEach>
                </c:if>
                </tbody>
            </table>
        </div>
    </form>
</div>


<!-- 进货模态框（Modal） -->
<form action="<%=basePath%>warehouse/addItems" method="post" id="register_form1">
    <div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 id="mytitle" class="modal-title" id="myModalLabel">
                        进货（已存在的货物）
                    </h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <i class="fa fa-items fa-lg"></i>
                        <input class="form-control required" type="text" id="name1" placeholder="商品名称" name="name" autofocus="autofocus"/>
                    </div>
                      <%--这个价格要调用数据库里面属性，根据输入的名称，往里面默认加入属性--%>
                    <div class="form-group">
                        <i class="fa fa-items fa-lg"></i>
                        <input class="form-control required" type ="text" placeholder="商品数量" id="number1" name="number"/>
                    </div>
                    <div class="form-group">
                        <label for="name">仓库编号</label>
                        <select class="form-control" name="location"/>
                        <option>Z</option>
                        <option>A</option>
                        <option>B</option>
                        </select>
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
<!-- 调度商品模态框（Modal） -->
<form action="<%=basePath%>warehouse/dispatchItem" method="post" id="dispatchModalForm">
    <input type="hidden" id="myid" name="myid"/>
    <div class="modal fade" id="dispatchModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title">调度商品
                    </h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <input class="form-control required" type="text" id="name2" placeholder="Name" name="name" autofocus="autofocus" disabled/>
                    </div>
<%--                    <div class="form-group">--%>
<%--                        <input class="form-control required" type="text" name="sourceDP" id="sourceDP" placeholder="源仓库" autofocus>--%>
<%--                    </div>--%>
                    <div class="form-group">
                        <input class="form-control required" type="text" name="destDP" id="destDP" placeholder="目的仓库" autofocus>
                    </div>
                    <div class="form-group">
                        <input class="form-control required" type="text" placeholder="调度数量" id="number3" name="number" autofocus="autofocus"/>
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


</body>
</html>
