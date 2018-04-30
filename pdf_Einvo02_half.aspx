﻿<%@ Page Language="C#" Debug="true"%>
    <script language="c#" runat="server">     
    	//電子發票證明聯  紙張 點陣 半張
        public class ParaIn{
            public string bno = "", eno = "", bdate = "", edate = "";
            //public string bno = "CE57084318", eno = "CE57084318", bdate = "", edate = "";
        }

        public class Invoice{
            public string noa;
            public Item[] item;
        }
        
        public class Item{
            public string accy, noa, noq;
            public string datea,invono,cust,serial,addr,product;
            public float mount,price,total,total2,total3,total4;
            public string memo;
            public float t_total;
            public string comp, comp_serial, comp_addr,taxtype;
       }

        public void drawLine(iTextSharp.text.pdf.PdfContentByte cb){
            cb.SetColorFill(iTextSharp.text.BaseColor.BLACK);
            cb.SetColorStroke(iTextSharp.text.BaseColor.BLACK);
            cb.SetLineWidth(1);

            cb.MoveTo(25, 272);//外框線
            cb.LineTo(590, 272);
            cb.LineTo(590, 20);
            
            cb.LineTo(25, 20);
            cb.LineTo(25, 272);

            cb.MoveTo(25, 250);//內框線(橫上)
            cb.LineTo(590, 250);

            cb.MoveTo(175, 272);//表身內框線(直)
            cb.LineTo(175, 150);
            
            cb.MoveTo(250, 272);
            cb.LineTo(250, 150);
            
            cb.MoveTo(325, 272);
            cb.LineTo(325, 60);
            
            cb.MoveTo(400, 272);
            cb.LineTo(400, 20);
            //----------------------- 稅別的直線
            cb.MoveTo(70, 125);
            cb.LineTo(70, 95);

            cb.MoveTo(109, 125);
            cb.LineTo(109, 95);

            cb.MoveTo(148, 125);
            cb.LineTo(148, 95);

            cb.MoveTo(187, 125);
            cb.LineTo(187, 95);

            cb.MoveTo(226, 125);
            cb.LineTo(226, 95);

            cb.MoveTo(265, 125);
            cb.LineTo(265, 95);
            //-----------------------
            cb.MoveTo(25, 150);//內框線(橫下)
            cb.LineTo(590, 150);
            cb.MoveTo(25, 125);
            cb.LineTo(590, 125);

            cb.MoveTo(25, 95);
            cb.LineTo(400, 95);

            cb.MoveTo(25, 60);
            cb.LineTo(400, 60);
            cb.Stroke();
        }
        public void inputTitle(iTextSharp.text.pdf.PdfContentByte cb ,Item[] item,int page){
            iTextSharp.text.pdf.BaseFont bfChinese,bold;
            if(Environment.OSVersion.Version.Major>6){
            	bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttc,0", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
           		bold = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttc,1", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            }else{
            	bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            	bold = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjhbd.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            }
            cb.BeginText();
            cb.SetFontAndSize(bfChinese, 24);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "電子發票證明聯", 310, 360, 0);
            cb.SetFontAndSize(bfChinese, 14);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, ((Item)item[0]).datea, 310, 335, 0);
            cb.SetFontAndSize(bfChinese, 12);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "發票號碼：" + ((Item)item[0]).invono, 25, 320, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, "格    式：25", 580, 320, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "買　　方：" + ((Item)item[0]).cust, 25, 307, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "統一編號：" + ((Item)item[0]).serial, 25, 294, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "地　　址：" + ((Item)item[0]).addr, 25, 281, 0);
            
            if (item.Length <= 6)
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, "第1頁/共1頁", 580, 281, 0);
            else if (item.Length > 6 && item.Length % 6 != 0)
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, "第" + page + "頁/" + "共" + ((item.Length / 6) + 1) + "頁", 580, 281, 0);
            else if (item.Length > 6 && item.Length % 6 == 0)
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, "第" + page + "頁/" + "共" + (item.Length / 6) + "頁", 580, 281, 0);
            
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "品名", 75, 255, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "數量", 200, 255, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "金額", 350, 255, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "單價", 275, 255, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "備註", 495, 255, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "銷售額合計", 30, 135, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)item[0]).total2.ToString(), 395, 135, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "營業稅", 30, 105, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "應稅", 79, 105, 0);
            if (((Item)item[0]).taxtype == "1")
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "√", 125, 105, 0);
            else if (((Item)item[0]).taxtype == "2")
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "√", 200, 105, 0);
            else if (((Item)item[0]).taxtype == "4")
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "√", 275, 105, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "零稅率", 150, 105, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "免稅", 235, 105, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)item[0]).total3.ToString(), 395, 105, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "總計", 30, 75, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)item[0]).total4.ToString(), 395, 75, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "營業人蓋統一發票專用章", 495, 135, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "總計新台幣", 30, 42, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "(中文大寫)", 30, 30, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ConvertInt(((Item)item[0]).total4.ToString()), 110, 36, 0);
            if (((Item)item[0]).comp.Length > 15){
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "賣方：" + ((Item)item[0]).comp.Substring(0, 15), 405, 105, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)item[0]).comp.Substring(15, ((Item)item[0]).comp.Length - 15), 405, 93, 0);
            }else{
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "賣方：" + ((Item)item[0]).comp, 405, 105, 0);
            }
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "統一編號：" + ((Item)item[0]).comp_serial, 405, 80, 0);
            //地址斷行的方式沒很完善,故先不做換行處理
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "地址：", 405, 56, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)item[0]).comp_addr, 405, 44, 0);
            cb.EndText();
        }
        
		private static string[] cstr = { "零", "壹", "貳", "叁", "肆", "伍", "陸", "柒", "捌", "玖" };
        private static string[] wstr = { "", "", "拾", "佰", "仟", "萬", "拾", "佰", "仟", "億", "拾", "佰", "仟" };
        public string ConvertInt(string str){
            int len = str.Length;
            int i;
            string tmpstr, rstr;
            rstr = "";
            for (i = 1; i <= len; i++){
                tmpstr = str.Substring(len - i, 1);
                rstr = string.Concat(cstr[Int32.Parse(tmpstr)] + wstr[i], rstr);
            }

            rstr = rstr.Replace("拾零", "拾");
            rstr = rstr.Replace("零拾", "零");
            rstr = rstr.Replace("零佰", "零");
            rstr = rstr.Replace("零仟", "零");
            rstr = rstr.Replace("零萬", "萬");
            for (i = 1; i <= 6; i++)
            rstr = rstr.Replace("零零", "零");
            rstr = rstr.Replace("零萬", "零");
            rstr = rstr.Replace("零億", "億");
            rstr = rstr.Replace("零零", "零");
            rstr += "元整";
            return rstr;
        }
		
        System.IO.MemoryStream stream = new System.IO.MemoryStream();
        string connectionString = "";
        public void Page_Load(){
        	string db = "st";
        	if(Request.QueryString["db"] !=null && Request.QueryString["db"].Length>0)
        	db= Request.QueryString["db"];
            connectionString = "Data Source=127.0.0.1,1799;Persist Security Info=True;User ID=sa;Password=artsql963;Database=" + db;
			//connectionString = "Data Source=60.249.177.127,1799;Persist Security Info=True;User ID=sa;Password=artsql963;Database=" + db;
			var item = new ParaIn();
            if (Request.QueryString["bno"] != null && Request.QueryString["bno"].Length > 0){
                item.bno = Request.QueryString["bno"];
            }
            if (Request.QueryString["eno"] != null && Request.QueryString["eno"].Length > 0){
                item.eno = Request.QueryString["eno"];
            }
            if (Request.QueryString["bdate"] != null && Request.QueryString["bdate"].Length > 0){
                item.bdate = Request.QueryString["bdate"];
            }
            if (Request.QueryString["edate"] != null && Request.QueryString["edate"].Length > 0){
                item.edate = Request.QueryString["edate"];
            }    
            //資料
            System.Data.DataSet ds = new System.Data.DataSet();
            
            using (System.Data.SqlClient.SqlConnection connSource = new System.Data.SqlClient.SqlConnection(connectionString)){
                System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter();
                connSource.Open();
                string queryString = @"
		        set @t_eno = case when len(@t_eno)=0 then char(255) else @t_eno end
                set @t_edate = case when len(@t_edate)=0 then char(255) else @t_edate end
                declare @tmpa table(
	                noa nvarchar(20)
	                ,n int
                )
                declare @tmpb table(
                    noa nvarchar(20),
                    noq nvarchar(10),
	                datea nvarchar(30),
	
	                invono nvarchar(50),
	                cust nvarchar(max),
	                serial nvarchar(50),
	                addr nvarchar(max),
	                product nvarchar(max),
	                mount float,
	                price float, --單價
	                total float, --金額
	                memo nvarchar(max),
	
	                total2 float,
		            total3 float,
		            total4 float,
	
	                comp nvarchar(max),
	                comp_serial nvarchar(50),
	                comp_addr nvarchar(max),
	                taxtype nvarchar(10)
                )
                insert into @tmpb(noa,noq,datea,invono,cust,serial,addr,product,mount,price,total,memo,comp,comp_serial,comp_addr,total3,taxtype,total4)
                select top 50 b.noa,b.noq,a.datea,a.noa,a.comp,a.serial,a.address,b.product,b.mount,b.price,b.money,b.memo,e.acomp,e.serial,e.addr,a.tax,a.taxtype,a.total
                from vcca a
                left join vccas b on a.noa = b.noa
                left join cust c on a.custno = c.noa
                left join acomp e on a.cno = e.noa
                where a.noa between @t_bno and @t_eno
                and a.datea between @t_bdate and @t_edate
                order by a.noa,b.noq

                insert into @tmpa(noa,n)select noa,count(1) from @tmpb group by noa order by noa

                update @tmpb set total2 = b.total
                from @tmpb a
                outer apply (select SUM(total) as total,noa from @tmpb where noa=a.noa group by noa)b
                update @tmpb set datea = convert(nvarchar,dbo.ChineseEraName2AD(datea),120)
                select * from @tmpa
                select * from @tmpb";
				
                System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(queryString, connSource);
                cmd.Parameters.AddWithValue("@t_bno", item.bno);
                cmd.Parameters.AddWithValue("@t_eno", item.eno);
                cmd.Parameters.AddWithValue("@t_bdate", item.bdate);
                cmd.Parameters.AddWithValue("@t_edate", item.edate);
                adapter.SelectCommand = cmd;
                adapter.Fill(ds);
                connSource.Close();
            }
            Invoice[] invoice = new Invoice[ds.Tables[0].Rows.Count];

            for (int i = 0; i < invoice.Length; i++){
                invoice[i] = new Invoice();
                invoice[i].noa = System.DBNull.Value.Equals(ds.Tables[0].Rows[i].ItemArray[0]) ? "" : (System.String)ds.Tables[0].Rows[i].ItemArray[0];
                invoice[i].item = new Item[System.DBNull.Value.Equals(ds.Tables[0].Rows[i].ItemArray[1]) ? 0 : (System.Int32)ds.Tables[0].Rows[i].ItemArray[1]];
                int n = 0;
                for(int j=0;j<ds.Tables[1].Rows.Count;j++){
                    if(invoice[i].noa == (System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[0]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[0])){
                        invoice[i].item[n] = new Item();        
                       
                        invoice[i].item[n].noa = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[0]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[0];
                        invoice[i].item[n].noq = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[1]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[1];
                        invoice[i].item[n].datea = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[2]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[2];
                        invoice[i].item[n].invono = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[3]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[3];
                        invoice[i].item[n].cust = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[4]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[4];
                        invoice[i].item[n].serial = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[5]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[5];
                        invoice[i].item[n].addr = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[6]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[6];
                        invoice[i].item[n].product = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[7]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[7];
                        invoice[i].item[n].mount = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[8]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[8];
                        invoice[i].item[n].price = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[9]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[9];
                        invoice[i].item[n].total = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[10]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[10];
                        invoice[i].item[n].memo = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[11]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[11];
                        invoice[i].item[n].total2 = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[12]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[12];
                        invoice[i].item[n].total3 = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[13]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[13];
                        invoice[i].item[n].total4 = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[14]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[14];
                        invoice[i].item[n].comp = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[15]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[15];
                        invoice[i].item[n].comp_serial = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[16]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[16];
                        invoice[i].item[n].comp_addr = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[17]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[17];
				        invoice[i].item[n].taxtype = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[18]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[18];
                        n++;
                    }  
                }
            }
            
            //-----PDF--------------------------------------------------------------------------------------------------
            var doc1 = new iTextSharp.text.Document(iTextSharp.text.PageSize.LETTER);
            float width = doc1.PageSize.Width;
            float height = doc1.PageSize.Height / 2;
            doc1 = new iTextSharp.text.Document(new iTextSharp.text.Rectangle(width, height), 0, 0, 0, 0);
            iTextSharp.text.pdf.PdfWriter pdfWriter = iTextSharp.text.pdf.PdfWriter.GetInstance(doc1, stream);
            //font
            iTextSharp.text.pdf.BaseFont bfChinese,bold;
            if(Environment.OSVersion.Version.Major>6){
            	bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttc,0", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
           		bold = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttc,1", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            }else{
            	bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            	bold = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjhbd.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            }
            iTextSharp.text.pdf.BaseFont bfNumber = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\ariblk.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            
            doc1.Open();
            iTextSharp.text.pdf.PdfContentByte cb = pdfWriter.DirectContent;
            if (invoice.Length == 0){
                cb.SetColorFill(iTextSharp.text.BaseColor.RED);
                cb.BeginText();
                cb.SetFontAndSize(bfChinese, 30);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "無資料", 20, 20, 0);
                cb.EndText();
            }else{
                for (int j = 0; j < invoice.Length; j++){
                    if(j>0)
                        doc1.NewPage();
                    for (int i = 0, y = 235, page = 1; i < invoice[j].item.Length; i++, y -= 15){
                        if (i == 0){
                            drawLine(cb);
                            inputTitle(cb, invoice[j].item, page);
                        }
                        if (i >= 6 && i % 6 == 0){
                            doc1.NewPage();
                            page++;
                            y = 235;
                            drawLine(cb);
                            inputTitle(cb, invoice[j].item, page);
                        }
                        //TEXT
                        cb.BeginText();
                        cb.SetFontAndSize(bfChinese, 11);
                        cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)invoice[j].item[i]).product, 30, y, 0);
                        cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)invoice[j].item[i]).mount.ToString(), 230, y, 0);
                        cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)invoice[j].item[i]).price.ToString(), 320, y, 0);
                        cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)invoice[j].item[i]).total.ToString(), 395, y, 0);
                        cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)invoice[j].item[i]).memo, 405, y, 0);
                        cb.EndText();
                    }
                }
                    
            }
            doc1.Close();
            Response.ContentType = "application/octec-stream;";
            Response.AddHeader("Content-transfer-encoding", "binary");
            Response.AddHeader("Content-Disposition", "attachment;filename=EinvoiceHalf.pdf");
            Response.BinaryWrite(stream.ToArray());
            Response.End();
        }
    </script>