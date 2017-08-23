<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title></title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
			$(document).ready(function() {
				q_getId();
				q_gf('', 'z_einvoice');
			});
			
			function q_gfPost() {
				//var a = '[{"date":"20170719"},{"date":"20170801"},{"date":"20170802"},{"date":"20170807"},{"date":"20170808"},{"date":"20170810"},{"date":"20170811"},{"date":"20170814"},{"date":"20170815"},{"date":"20170821"},{"date":"20170822"}]';
				//finish(JSON.parse(a));
				$.ajax({
					rdate : [],
                    url: "../einvoice/SummaryResult.aspx",
                    headers: { 'db': q_db },
                    type: 'POST',
                    //data: JSON.stringify(datea[0]),
                    dataType: 'text',
                    timeout: 10000,
                    success: function(data){
                        if(data.length>0){
                        	rdate = JSON.parse(data);
                        }
                    },
                    complete: function(){ 
                    	finish(rdate);
                    },
                    error: function(jqXHR, exception) {
                        var errmsg = this.url+'資料寫入異常。\n';
                        if (jqXHR.status === 0) {
                            alert(errmsg+'Not connect.\n Verify Network.');
                        } else if (jqXHR.status == 404) {
                            alert(errmsg+'Requested page not found. [404]');
                        } else if (jqXHR.status == 500) {
                            alert(errmsg+'Internal Server Error [500].');
                        } else if (exception === 'parsererror') {
                            alert(errmsg+'Requested JSON parse failed.');
                        } else if (exception === 'timeout') {
                            alert(errmsg+'Time out error.');
                        } else if (exception === 'abort') {
                            alert(errmsg+'Ajax request aborted.');
                        } else {
                            alert(errmsg+'Uncaught Error.\n' + jqXHR.responseText);
                        }
                    }
                });
			}
			
			function finish(rdate){
				$('#q_report').q_report({
					fileName : 'z_einvoice',
					options : [{
						type : '0', //[1]
						name : 'path',
						value : location.protocol + '//' +location.hostname + location.pathname.toLowerCase().replace('z_einvoice.aspx','')
					},{
						type : '0', //[2]
						name : 'db',
						value : q_db
					}, {
						type : '6', //[3]  1
						name : 'xdate'
					}]
				});
				q_popAssign();
				
				for(var i=0;i<rdate.length;i++){
					$('#listDate').append('<option value="'+rdate[i].date+'"></option>');
				}
				$('#txtXdate').attr("list","listDate");
				/*var t_para = new Array();
	            try{
	            	t_para = JSON.parse(q_getId()[3]);
	            }catch(e){
	            }    
	            if(t_para.length==0 || t_para.noa==undefined){
	            }else{
	            	$('#txtXnoa1').val(t_para.noa);
	            	$('#txtXnoa2').val(t_para.noa);
	            }*/
			}

			function q_getPrintPost(){
				var t_noa = $.trim($('#txtXnoa').val());
				if(t_noa.length > 0){
					$('#btnOk').click();
				}
			}

			function q_boxClose(s2) {
			}

			function q_gtPost(s2) {
			}
		</script>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div id="q_menu"></div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"></div>
			</div>
			<div class="prt" style="margin-left: -40px;">
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>
		<datalist id="listDate"> </datalist>
	</body>
</html>