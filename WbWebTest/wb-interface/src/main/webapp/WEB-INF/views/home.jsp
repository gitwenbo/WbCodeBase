<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>templateStudy</title>
    <script src="/lib/js/jquery-3.3.1.js"></script>
    <script src="/lib/js/handlebars-v4.0.10.js"></script>
    <script src="/lib/js/handlebars-jquery.js"></script>

    <script id="stuTempId" type="text/x-handlebars-template">
        <section>
            <ul>
                {{#each stu}}
                <li>{{@index}}:{{@key}}:{{this}}</li>
                {{/each}}
            </ul>
        </section>
        <table border="1px">
            <tr><td>serial number</td><td>student number</td><td>name</td><td>age</td><td>serial number</td><td>name</td><td>email</td></tr>
            {{#each stus}}
            <tr>
                <td>{{@index}}</td>
                <td>{{id}}</td>
                <td>{{name}}</td>
                <%--<td>{{#if age}}{{age}}{{else}}no filed{{/if}}</td>--%>
                <td>{{#if email}}{{email}}{{else}}no filed{{/if}}</td>
                <td>{{@key}}</td>
                <td>{{this.name}}</td>
                <td>{{#with this}}{{email}}{{/with}}</td>
            </tr>
            {{/each}}
        </table>
    </script>
    <script type="text/javascript">
        $(function () {
            var data={
                stus:[
                    {id:100,name:"apple1",age:11},
                    {id:200,name:"apple2"},
                    {id:300,name:"apple3",age:33},
                ],
                stu:{id:300,name:"apple3",age:33}
            };

            $.ajax({
                type: 'post',
                url: '/students',
                contentType : 'application/json;charset=utf-8',
                data : '{"id":1, "email":"someemail@someemailprovider"}',
                success: function (result) {
                    $("#stuInfoId").empty().append($("#stuTempId").template(result).filter("*"));  //filter("*")用于匹配所有html节点，过滤掉文本节点
                },
                error: function () {
                }
            });
        });
    </script>
</head>
<body>
<section id="stuInfoId"></section>
</body>
</html>