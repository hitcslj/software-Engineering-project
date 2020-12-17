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
    <title>批发订单管理</title>
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="<%=basePath%>js/jquery-3.5.1.js" ></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js">
    </script>
    <script type="text/javascript">
        var i = 0;
        function next() {
            if(i < itemname.length){
                var InputInfo = document.getElementsByName("number");
                for(var k = 0; k < InputInfo.length; k++){
                    inputnumber[i][k] = InputInfo[k].value;
                }
                if(i < itemname.length - 1) i++;
                item.innerHTML = "商品<input type='text' name='itemName'  id='itemName' value=" +  itemname[i] + " disabled/><br>"
                    + "数量<input type='text' name='itemNumber'  id='itemNumber' value=" + number[i] +  "(" + isEnough[i] + ")" +" disabled/><br>"
                var HTML = "";
                for(var k = 0; k < wareHouse[i].length; k++){
                    inputnumber[i][k] = inputnumber[i][k]==undefined?"":inputnumber[i][k];
                    HTML += "仓库" + wareHouse[i][k] +  "<input name='number' " +" value=" + inputnumber[i][k] +  "><br>";
                }
                numberinfo.innerHTML = HTML;
            }
        }
        function pre() {
            if(i >= 0){
                var InputInfo = document.getElementsByName("number");
                for(var k = 0; k < InputInfo.length; k++){
                    inputnumber[i][k] = InputInfo[k].value;
                }
                if(i > 0) i--;
                item.innerHTML = "商品<input type='text' name='itemName'  id='itemName' value=" +  itemname[i] + " disabled/><br>"
                    + "数量<input type='text' name='itemNumber'  id='itemNumber' value=" + number[i] +  "(" + isEnough[i] + ")" + " disabled/><br>";
                var HTML = "";
                for(var k = 0; k < wareHouse[i].length; k++){
                    inputnumber[i][k] = inputnumber[i][k]==undefined?"":inputnumber[i][k];
                    HTML += "仓库" + wareHouse[i][k] +  "<input name='number' " + " value=" + inputnumber[i][k] + "><br>";
                }
                numberinfo.innerHTML = HTML;
            }
        }
        function send(){
            var distribution= orderid+"=";
            for(var k = 0; k < itemname.length; k++){
                distribution += itemname[k] + ":";
                for(var j = 0; j < inputnumber[k].length; j++){
                    inputnumber[k][j] = inputnumber[k][j]==""?0:inputnumber[k][j];
                    distribution += inputnumber[k][j] + " ";
                }
                distribution += "-";
            }
            $.ajax({
                url:"<%=basePath%>warehouse/distributeItems",
                data:{distribution:distribution},
                success:function (data){ //data封装了服务器返回的数据
                    $("#distributeModal").modal("hide");
                    $("#PAGE").html(data);
                }
            });
        }
        function submit(){
            var flag = true;
            var enough = true;
            var InputInfo = document.getElementsByName("number");
            var pos;
            for(pos = 0; pos < isEnough.length; pos++){
                if(isEnough[pos]=="缺货"){
                    enough = false;
                    break;
                }
            }
            if(enough) {
                for (var k = 0; k < InputInfo.length; k++) {
                    inputnumber[i][k] = InputInfo[k].value;
                }
                for (var j = 0; j < itemname.length && flag; j++) {
                    var total = 0;
                    for (var k = 0; k < inputnumber[j].length; k++) {
                        var n = inputnumber[j][k] == "" ? 0 : inputnumber[j][k];
                        total += parseInt(n);
                    }
                    if (total != parseInt(number[j])) {
                        flag = false;
                        alert("商品" + itemname[j] + "数量分配不对");
                    }
                }
                if (flag) {
                    send();
                }
            }
            else {
                alert(itemname[pos] + "缺货");
            }
        }
        function init(id){
            orderid = id;
            isEnough = new Array();
            number = new Array();
            wareHouse = new Array();
            inputnumber = new Array();
            orderiddiv = document.getElementById("orderid");
            item = document.getElementById("item");
            numberinfo = document.getElementById("numberinfo");
            itemname = new Array();
            $.get({
                url:"<%=basePath%>warehouse/getOrderItemInfo",
                data: {id:id},
                success:function (data){ //data封装了服务器返回的数据
                    itemname = data[0];
                    number = data[1];
                    isEnough = data[data.length-1];
                    for(var k = 0; data[k + 2] != undefined; k++)
                    {
                        wareHouse[k] = data[k + 2];
                        inputnumber[k] = new Array();
                    }
                    orderiddiv.innerHTML = "订单编号<input type='text' name='orderId'  id='orderId' value=" +  orderid +  " disabled/><br>"
                    item.innerHTML = "商品<input type='text' name='itemName'  id='itemName' value=" +  itemname[0] + " disabled/><br>"
                        + "数量<input type='text' name='itemNumber'  id='itemNumber' value=" + number[0]  + "(" + isEnough[0] + ")" + " disabled/><br>"
                    var HTML = "";
                    for(var k = 0; k < wareHouse[0].length; k++){
                        inputnumber[0][k] = inputnumber[0][k]==undefined?"":inputnumber[0][k];
                        HTML += "仓库" + wareHouse[0][k] +  "<input name='number'" + " value=" + inputnumber[0][k] +  "><br>";
                    }
                    numberinfo.innerHTML = HTML;
                    $("#distributeModal").modal("show");
                }
            });
        }
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
            $("#state").val("");
            $("#type").val("");
        }
        function loginOut(obj){
            if (confirm('您确定要退出系统吗？')) {
                obj.href = "<%=basePath%>user/loginOut";
                obj.onclick = "";
                obj.click();
            }
        }
    </script>
</head>
<body style="background-color: #d7f5e9" id="PAGE">
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
                <a class="navbar-brand active" href="<%=basePath%>warehouse/selectAll">仓库</a>
            </div>
            <div class="navbar-header">
                <a class="navbar-brand active" href="#">批发单</a>
            </div>
        </div>
    </nav>
</div>

<div class="table-responsive" id="INFO">
    <form class="form-inline" role="form" action="<%=basePath%>warehouse/selectOrderByParams" method="post" id="myform">
        <div style="margin-left: 80px;">
            客户名：<input type="text" name="customerName" id="name"  class="form-control" style="width: 120px;">
            <input type="hidden" name="state" id="state"  value="未审核" class="form-control" style="width: 120px;">
            类型：<input type="text" name="type" id="type"  class="form-control"  style="width: 120px;">
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
                    <th style="text-align: center">状态</th>
                </tr>
                </thead>
                <tbody>
                <c:if test="${!empty orderList}">
                    <c:forEach items = "${orderList}" var="order" varStatus="status">
                        <tr style="text-align: center">
                            <td>
                                <button type="button" class="btn btn-info" onclick="init('${order.id }')">分配</button>
                            </td>
                            <td>${order.id }</td>
                            <td>${order.customerName }</td>
                            <td>${order.telephone }</td>
                            <td>${order.state}</td>
                        </tr>
                    </c:forEach>
                </c:if>
                </tbody>
            </table>
        </div>
    </form>
</div>
<!-- 订单分配模态框（Modal） -->
<div class="modal fade" id="distributeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
            </div>
            <div class="modal-body">
                <div id="orderid">
                </div>
                <div id="item">
                </div>
                <div id="numberinfo">
                </div>
                <input type="button" value="Pre" id="pre" onclick="pre()">
                <input type="button" value="Next" id="next" onclick="next()"><br>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
                <input type="button" value="提交" id="submit" onclick="submit()">
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>
</body>
</html>
