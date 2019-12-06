<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SPMJXWL_Vote.aspx.cs" Inherits="WeChatClient.YSH.Modules.Event.SPMJXWL_Vote" %>

<%@ Register Src="~/Component/EventHeadPart.ascx" TagPrefix="uc1" TagName="EventHeadPart" %>
<%@ Register Src="~/Component/EventMainNavPart.ascx" TagPrefix="uc1" TagName="EventMainNavPart" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
    <title>视频大赛</title>
    <link href="../../Content/css/weui.css" rel="stylesheet" />
    <link href="../../Content/css/event.css" rel="stylesheet" />
    <style type="text/css">
        #HeadHeight {
            background-color: #FFF !important;
        }

        img {
            width: 100%;
        }

        .votebody {
            background-color: #000;
        }

            .votebody p {
                color: #f18101;
                font-size: 10px;
            }

        .VoteDiv {
            text-align: center;
        }

            .VoteDiv img {
                width: 80%;
            }

        .query_Img {
            width: 50%;
            margin: 0 25%;
        }

        .query_title {
            width: 33%;
            margin-left: 66%;
        }

        .weui-cell:before {
            border-top: none;
        }

        .count {
            font-size: 16px !important;
            text-align: right;
            margin: 0 2% 2% 0;
        }

        /*.dailog {
            background: url(../../Content/image/Event/DaiLog.png) no-repeat;
            background-size: 100%;
            width: 80%;
            height: 300px;
            margin: 0 10%;
        }

        #close {
            width: 30px;
        }*/

        .p2_box {
            width: 100%;
        }

        #p2_box_img1 {
            width: 90%;
            margin: 40% 5%;
            position: absolute;
            z-index: 10;
        }

        #p2_box_img2 {
            width: 20px;
            position: absolute;
            z-index: 20;
            margin-top: 44%;
            margin-left: 85%;
        }
    </style>
</head>
<body>
    <uc1:EventHeadPart runat="server" ID="EventHeadPart" />
    <uc1:EventMainNavPart runat="server" ID="EventMainNavPart" />


    <img src="../../Content/image/Event/banner02.png" />

    <div class="dailog" style="">
    </div>
    <div class="p2_box weui-mask weui-animate-fade-in" style="display: none">
        <img src="../../Content/image/Event/DaiLog.png" id="p2_box_img1" />
        <img src="../../Content/image/Event/Icon_close.png" id="p2_box_img2" onclick="closeBox()" />
    </div>

    <div class="votebody">
        <div class="weui-flex" style="width: 90%; margin: 0 5%;">
            <div class="weui-flex__item VoteDiv">
                <img src="../../Content/image/Event/btn_2.png" onclick="openBox()" />
            </div>
            <div class="weui-flex__item VoteDiv">
                <img src="../../Content/image/Event/my_vote.png" onclick="location.href='SPMJXWL_UserVote.aspx'" />
            </div>
        </div>
        <img src="../../Content/image/Event/query_0.png" id="query" class="query_Img" />
        <img src="../../Content/image/Event/little_title.png" class="query_title" />

        <div id="ContentList"></div>
    </div>

    <script src="../../Content/script/jquery-3.2.1.min.js"></script>
    <script src="../../Content/script/weui.js"></script>
    <script src="../../Content/script/BasePage.js"></script>
    <script src="../../Content/script/event.js"></script>

    <script>
        var AppID = getQueryString('AppID');
        var userID = getCookie('cookieUserId');
        var userName = getCookie('cookieUsername');
        //打开
        function openBox() {
            $('.p2_box').css('display', '');
        }
        //关闭
        function closeBox() {
            $('.p2_box').css('display', 'none');
        }

        //获取COURSE列表
        GetCourseVODList();
        function GetCourseVODList() {
            var TempListRow = '';
            var URL = url + 'course/appID/' + appID_YSH + '?categoryids=17&pageIndex=0&pageSize=9999&sort=DESC&parentId=1521';

            $(".weui-loadmore").attr('style', 'display:block');//显示load
            $.ajax(URL, {
                dataType: 'json',
                beforeSend: function (xhr) {
                    xhr.setRequestHeader("Authorization", "Bearer " + OAuthToken);
                },
                success: function (data) {
                    if (jQuery.isEmptyObject(data)) {
                        TempListRow += '';
                    } else {
                        console.log(data)
                        for (var i = 0; i < data.result.length; i++) {

                            TempListRow += '<div class="weui-cell"  onclick="window.location.href=\'SPMJXWL_VotePlayer.aspx?ID=' + data.result[i].id + '&AppID=' + appID_YSH + '\'"><div class="weui-cell__hd" style="position: relative; margin-right: 10px;"><img src="' + data.result[i].mediumCoverUrl + '" style="width: 90px; display: block"></div><div class="weui-cell__bd"><p style="font-size: 16px;">' + data.result[i].title + '</p><p class="count">' + data.result[i].favouriteCount + '票</p><p style="line-height: 10px;">' + data.result[i].teacher + '教授</p><p>' + data.result[i].subTitle + '</p><img src="../../Content/image/Event/btn_1.png" style="width: 30%; float: right; margin-top: -12%;" /></div></div>';
                        }
                    }
                },
                complete: function (msg) {
                    loading = false;
                    $("#ContentList").append(TempListRow);
                }
            });
        }
        //获取COURSE列表

        //获取我的票数
        GetUserFavoritr();
        function GetUserFavoritr() {
            var URL = url + 'UserFavorite/course/ParentId/1521?userId=' + userID;
            $.ajax(URL, {
                dataType: 'json',
                beforeSend: function (xhr) {
                    xhr.setRequestHeader("Authorization", "Bearer " + OAuthToken);
                },
                success: function (data) {
                    console.log(data.totalCount)
                    document.getElementById("query").src = '../../Content/image/Event/query_' + data.totalCount + '.png';
                },
                complete: function (msg) {

                }
            });
        }
        //获取我的票数
    </script>
</body>
</html>
