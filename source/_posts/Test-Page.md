---
title: 测试页面
date: 2010-08-27 11:41:03
author: Tokisaki Galaxy
img: https://src.onlinedown.net/d/file/p/2019-02-21/0d7b1ece1e9daf93d082fadc8fdbcbdf.jpg
coverImg:
top: false
cover: false
toc: true
mathjax: false
summary: 测试页面。
categories:
  - 博客
password:
comments: false
noindex: true
sitemap: false
reprintPolicy: cc_by
---

<style>
a {
	text-decoration: none!important
}

#globalAd {
	max-width: 400px;
	flex-basis: 100%;
	margin: 0 auto;
	background: #fff;
	border-radius: 10px;
	box-shadow: 0 0 30px rgba(0, 0, 0, .3);
	-webkit-box-shadow: 0 0 30px rgba(0, 0, 0, .3);
	overflow: hidden;
	position: fixed;
	display: none;
	margin: 0 auto;
	z-index: 10001
}

.layer {
	width: 100%;
	height: 100%;
	position: fixed;
	top: 0;
	left: 0;
	filter: alpha(opacity=50);
	opacity: .5;
	background: #000;
	z-index: 1000;
	display: none
}

#globalAd #hero-img {
	width: 100%;
	height: 100px;
	background: #007bff
}

#globalAd #profile-img {
	width: 80px;
	height: 80px;
	margin: -80px auto 0;
	border: 6px solid #fff;
	border-radius: 50%;
	box-shadow: 0 0 5px rgba(90, 90, 90, .3)
}

#globalAd #profile-img img {
	width: 100%;
	background: #fff;
	border-radius: 50%
}

#globalAd #content {
	text-align: center;
	width: 320px;
	margin: 0 auto;
	padding: 0 0 50px
}

#container #content h1 {
	font-size: 29px;
	font-weight: 500;
	margin: 50px 0 0
}

#globalAd #content p {
	font-size: 18px;
	font-weight: 400;
	line-height: 1.4;
	color: #666;
}

#globalAd #content a {
	color: #ccc;
	font-size: 14px;
	margin: 0 10px;
	transition: color .3s ease-in-out;
	-webkit-transition: color .3s ease-in-out
}

#globalAd #content a:hover {
	color: #007bff
}

#globalAd #content .btn {
	background: none repeat scroll 0 0 #1ba1e2;
	border: 0;
	border-radius: 2px;
	color: #fff!important;
	cursor: pointer;
	font-family: open sans, hiragino sans gb, microsoft yahei, wenquanyi micro hei, Arial, Verdana, Tahoma, sans-serif;
	font-size: 14px;
	padding: 6px 10%
}

#globalAd #content .btn:hover,
.yanshibtn:hover {
	background: none repeat scroll 0 0 #9b59b6;
	border: 0;
	border-radius: 2px;
	color: #fff!important;
	cursor: pointer;
	font-family: open sans, hiragino sans gb, microsoft yahei, wenquanyi micro hei, Arial, Verdana, Tahoma, sans-serif;
	font-size: 14px;
	padding: 8px 10%
}
</style>

<div class="layer"></div>
		<div id="globalAd">
			<div id='hero-img' style="background-color: #1a95ff;background: linear-gradient(to left, #5dadf3 0, #4583ca 100%);">
			</div>
			<div id='profile-img'>
				<img src="1.jpg" />
			</div>
			<div id='content'>
				<p style="font-size: 16px;font-weight: bold;">冰豆网公告</p>
				<p>冰豆网提示你</p>
				<p>使用cookie记录</p>
				<p>一天只弹一次</p>
				<p>为了好看！冲啊啊啊啊啊！</p>
				<p>冰豆网</p>
				<a onClick="closeGlobalAd();" class="btn btn-default" rel='nofollow'>朕已阅</a>
				<a href="https://www.bingdou.net" onClick="redirectUrlToActive();" class="btn btn-default" rel='nofollow'>点击访问</a>
	</div>
</div>
<script src="https://api.bingdou.net/js/js.js"></script>
<script>
			jQuery.cookie = function(name, value, options) {
				if(typeof value != 'undefined') {
					options = options || {};
					if(value === null) {
						value = '';
						options.expires = -1;
					}
					var expires = '';
					if(options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
						var date;
						if(typeof options.expires == 'number') {
							date = new Date();
							var totalTime = 24 * 3600;
							var hour = date.getHours();
							var minutes = date.getMinutes();
							var seconds = date.getSeconds();
							var pastTime = 3600 * hour + 60 * minutes + seconds;
							var leftTime = totalTime - pastTime;
							date.setTime(date.getTime() + (options.expires * leftTime * 1000));
						} else {
							date = options.expires;
						}
						expires = '; expires=' + date.toUTCString();
					}
					var path = options.path ? '; path=' + (options.path) : '';
					var domain = options.domain ? '; domain=' + (options.domain) : '';
					var secure = options.secure ? '; secure' : '';
					document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
				} else {
					var cookieValue = null;
					if(document.cookie && document.cookie != '') {
						var cookies = document.cookie.split(';');
						for(var i = 0; i < cookies.length; i++) {
							var cookie = jQuery.trim(cookies[i]);
							if(cookie.substring(0, name.length + 1) == (name + '=')) {
								cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
								break;
							}
						}
					}
					return cookieValue;
				}
			};
			$(function() {
				var COOKIE_NAME = "erdangjiade";
				if($.cookie(COOKIE_NAME)) {
					$(".layer").hide();
					$("#globalAd").hide();
				} else {
					var erdangjiadeH = $(window).height();
					var erdangjiadeW = $(window).width();
					$(".layer").show();
					$("#globalAd").css({
						'top': erdangjiadeH / 2 - $("#globalAd").height() / 2,
						'left': erdangjiadeW / 2 - $("#globalAd").width() / 2
					});
					$("#globalAd").slideDown(300, function() {
						setTimeout("closeGloableAd()", '300000');
					});
					$.cookie(COOKIE_NAME, "erdangjiade", {
						path: '/',
						expires: 1
					});
				}
			});

			function closeGlobalAd() {
				$('#globalAd').hide();
				$('.layer').hide();

			}

			function redirectUrlToActive() {
				$('#globalAd').hide();
				$('.layer').hide();
			}
</script>

https://evil-binary.github.io/
https://evil-binary.github.io/
https://evil-binary.github.io/

https://tokisakigalaxy.xyz/

<link rel="stylesheet" href="https://cdn.bootcss.com/aplayer/1.10.1/APlayer.min.css">
<div id="aplayer"></div>
<script src="https://cdn.bootcss.com/aplayer/1.10.1/APlayer.min.js"></script>
<script>const ap = new APlayer({    container: document.getElementById('aplayer'),
    audio: [{
        name: 'Renegade',
        artist: '塞壬唱片-MSR',
        url: 'http://music.163.com/song/media/outer/url?id=1444493657.mp3',
        cover: 'http://p1.music.126.net/qKU7UETrrdH-x7cZf-FfIw==/109951164949003058.jpg'
    }]});</script>

!!! warning
    这是一条采用默认标题的警告信息。

![主界面](https://s2.ax1x.com/2020/02/09/1h5Vqs.png)


{% img [主界面] https://s2.ax1x.com/2020/02/09/1h5Vqs.png %}

