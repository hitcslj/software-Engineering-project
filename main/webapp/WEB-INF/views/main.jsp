<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    /*获取工程路径*/
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
    <title>主界面</title>
    <script src="https://cdn.bootcss.com/jquery/2.1.1/jquery.min.js"></script>
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<%--    <style type="text/css">--%>
<%--        body{height:100%;background: url(<%=basePath%>img/re.png) no-repeat center/cover;font-size:16px;padding-top:1px;margin-top:-1px;}--%>
<%--    </style>--%>
    <script type="text/javascript">
        $(function () {
            $("#userManager").attr("class","active");
            $("#frm_right").attr("src","<%=basePath%>user/selectAll");
        });

        function menuClick(obj,url){
            if(obj==1){
                $("#userManager").attr("class","active");
                $("#customerManager").attr("class","");
                $("#menuManager").attr("class","");
            }
            if(obj==2){
                $("#customerManager").attr("class","active");
                $("#userManager").attr("class","");
                $("#menuManager").attr("class","");
            }
            if(obj==3){
                $("#menuManager").attr("class","active");
                $("#customerManager").attr("class","");
                $("#userManager").attr("class","");
            }

            $("#frm_right").attr("src",url);
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
        //主界面自适应高度   这个函数要在frm_right加载完了调用才有用
        function mainHeight() {
            var ifm= document.getElementById("frm_right");
            var subWeb =document.frames ? document.frames["frm_right"].document : ifm.contentDocument;
            if(ifm != null && subWeb != null) {
                var hg=subWeb.body.scrollHeight;
                ifm.height = hg<600?600:hg;
            }
        }
    </script>
</head>
<body style="background-color: #d7f5e9">
<%--导航栏和用户信息--%>
<div>
    <nav class="navbar navbar-default" role="navigation">
        <div class="container-fluid">
            <ul class="nav navbar-nav navbar-left">
                <li><a href="#">您好:${userInfo.loginName} boss,欢迎登入</a></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li><a href="javascript:void(0)" onclick="loginOut(this)"><span class="glyphicon glyphicon-user"></span> 退出</a></li>
            </ul>
        </div>
    </nav>
    <%--<nav class="navbar navbar-default" role="navigation">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand" href="#"></a>
            </div>
            <div>
                <ul class="nav navbar-nav" id="top" style="font-size: 16px;">
                    <li id="userManager"><a href="javascript:void(0)" onclick="menuClick(1,'<%=basePath%>user/selectAll')">员工管理</a></li>
                    <li id="customerManager"><a href="javascript:void(0)" onclick="menuClick(2,'<%=basePath%>customer/selectAll')">客户管理</a></li>

                </ul>
                <ul class="nav navbar-nav navbar-right">
                        <li><a href="<%=basePath%>items/selectAll">商品列表</a></li>
                    </ul>
            </div>
        </div>
    </nav>--%>

</div>
<%--下方主界面--%>
<div style=" text-align: center;height: 100%;">
    <iframe frameborder="0" name="frm_right" id="frm_right"	width="100%" scrolling="no" src="" style="margin:0px auto 0px auto; background-color: #ffffff;padding: 0px" ></iframe>
</div>
</body>
</html>

