<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"> </script>
		<script src='../script/qj2.js' type="text/javascript"> </script>
		<script src='qset.js' type="text/javascript"> </script>
		<script src='../script/qj_mess.js' type="text/javascript"> </script>
		<script src="../script/qbox.js" type="text/javascript"> </script>
		<script src='../script/mask.js' type="text/javascript"> </script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"> </script>
		<script src="css/jquery/ui/jquery.ui.widget.js"> </script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"> </script>
		<script type="text/javascript">
             
            $(document).ready(function() {
            	q_getId();
                q_gf('', 'z_vccb');
               
            });
            function q_gfPost() {
                $('#q_report').q_report({
                    fileName : 'z_vccb',
                    options : [ {
                        type : '6',
                        name : 'xnoa'
                    },{
                    	type : '0',
                        name : 'xlen',
                        value : r_len
                    }]
                });
                q_popAssign();
                
                if(q_getHref()[1]!=undefined)
                	$('#txtXnoa').val(q_getHref()[1]);
                	
                $('#btnOk').before($('#btnOk').clone().attr('id', 'btnOk2').attr('value','查詢').show()).hide();
				$('#btnOk2').click(function() {
					var t_noa = $.trim($('#txtXnoa').val());
					
					switch($('#q_report').data('info').radioIndex) {
						case 0:
							window.open("./pdf_vccb02_rs.aspx?db="+q_db+"&bvccbno="+t_noa+"&evccbno="+t_noa);
							break;
						case 1:
							window.open("./pdf_vccb02.aspx?db="+q_db+"&bvccbno="+t_noa+"&evccbno="+t_noa);
							break;
                  		default:
                  			$('#btnOk').click();
                  			break;
                  	}
					
				});
	        }

            function q_boxClose(s2) {
            }
            function q_gtPost(s2) {
            }
	</script>
	<style type="text/css">
		
	</style>
	</head>
	<body ondragstart="return false" draggable="false"
        ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"  
        ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"  
        ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
     >
		<div id="q_menu"> </div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"> </div>
			</div>
			<div class="prt" style="margin-left: -40px;">
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>
	</body>
</html>