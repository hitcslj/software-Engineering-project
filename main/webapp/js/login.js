$().ready(function() {
    $("#login_form").validate({
        rules: {
            loginName: "required",
            password: {
                required: true,
                minlength: 1
            },
        },
        messages: {
            loginName: "请输入登入名",
            password: {
                required: "请输入密码"

            },
        }
    });
    $("#register_form").validate({
        rules: {
            loginName: "required",
            age:{
                digits:true,
                min:0,
                max:120
            },
            password: {
                required: true,
                minlength: 1
            },
            rpassword: {
                equalTo: "#register_password"
            }
        },
        messages: {
            name:"请输入您的姓名",
            loginName: "请输入登入名",
            age:{
                required:"请输入您的年龄"
            },
            password: {
                required: "请输入密码"
            },
            rpassword: {
                equalTo: "两次密码不一样",
                required: "请再次输入密码"
            }
        }
    });
});
$(function() {
    $("#register_btn").bind("click",function () {
        $("#register_form").css("display", "block");
        $("#login_form").css("display", "none");
    });
    $("#back_btn").bind("click",function () {
        $("#register_form").css("display", "none");
        $("#login_form").css("display", "block");
    });
});
