
/**
 * 아이디, 닉네임, 이메일 , 휴대폰 중복 체크
 * 
 * JS 파일에는 태그 없어야 한다.
 * @returns
 */

var isUidOk 	= false;
var isNickOk 	= false;
var isEmailOk 	= false;
var isHpOk 		= false;
					
$(function(){
			//아이디 중복 체크
			$('input[name=uid]').blur(function(){ // focusout 함수 써도 됨.
				var tag = $(this);
				var uid = $(this).val(); //여기 this 는 input text 안의 내용임
							
				$.ajax({
					url: './proc/checkUid.jsp?uid='+uid,
					type: 'get',
					dataType: 'json', //받아올 데이터 타입
					success: function(json){  //성공했을 때 콜백함수
					//	alert(json.result); //Map 함수라서 key값 넣으면 value 값 받음 
						if(json.result == 1) {
							$('.resultId').css('color', 'red').text('이미 사용중입니다.');
							isUidOk = false;
							tag.focus(); //$(this)는 안 먹힌다.
						
						}else{
							$('.resultId').css('color', 'green').text('사용할 수 있습니다.');
							isUidOk = true;
						}
					
					} 
				});
			});
			//nickname
			$('input[name=nick]').blur(function(){ // focusout 함수 써도 됨.
				var tag = $(this);
				var nick = $(this).val(); //여기 this 는 input text 안의 내용임
							
				$.ajax({
					url: './proc/checkNick.jsp?nick='+nick,
					type: 'get',
					dataType: 'json', //받아올 데이터 타입
					success: function(json){  //성공했을 때 콜백함수
					//	alert(json.result); //Map 함수라서 key값 넣으면 value 값 받음 
						if(json.result == 1) {
							$('.resultNick').css('color', 'red').text('이미 사용중입니다.');
							isNickOk = false;
							tag.focus(); //$(this)는 안 먹힌다.
						}else{
							$('.resultNick').css('color', 'green').text('사용할 수 있습니다.');
							isNickOk = true;
						}
					} 
				});
			});
			//email
			$('input[name=email]').blur(function(){ // focusout 함수 써도 됨.
				var tag = $(this);
				var email = $(this).val(); //여기 this 는 input text 안의 내용임
							
				$.ajax({
					url: './proc/checkEmail.jsp?email='+email,
					type: 'get',
					dataType: 'json', //받아올 데이터 타입
					success: function(json){  //성공했을 때 콜백함수
					//	alert(json.result); //Map 함수라서 key값 넣으면 value 값 받음 
						if(json.result == 1) {
							$('.resultEmail').css('color', 'red').text('이미 사용중입니다.');
							isEmailOk = false;
							tag.focus(); //$(this)는 안 먹힌다.
						}else{
							$('.resultEmail').css('color', 'green').text('사용할 수 있습니다.');
							isEmailOk = true;
						}
					} 
				});
			});
			
			//hp
			$('input[name=hp]').blur(function(){ // focusout 함수 써도 됨.
				var tag = $(this);
				var hp = $(this).val(); //여기 this 는 input text 안의 내용임
							
				$.ajax({
					url: './proc/checkHp.jsp?hp='+hp,
					type: 'get',
					dataType: 'json', //받아올 데이터 타입
					success: function(json){  //성공했을 때 콜백함수
					//	alert(json.result); //Map 함수라서 key값 넣으면 value 값 받음 
						if(json.result == 1) {
							$('.resultHp').css('color', 'red').text('이미 사용중입니다.');
							isHpOk = false;
							tag.focus(); //$(this)는 안 먹힌다.
						}else{
							$('.resultHp').css('color', 'green').text('사용할 수 있습니다.');
							isHpOk = true;
						}
					} 
				});
			});
		});