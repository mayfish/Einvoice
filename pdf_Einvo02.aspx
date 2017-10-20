<%@ Page Language="C#" Debug="true"%>
    <script language="c#" runat="server">     
    	//電子發票證明聯
        public class ParaIn
        {
            public string noa="", noq="",acomp="";
        }

        public class Para
        {
            public string accy, noa, noq;
            public string datea,invono,cust,serial,addr,product;
            public float mount,price,total,total2,total3,total4;
            public string memo;
            public float t_total;
            public string comp, comp_serial, comp_addr;
       }

        public void drawLine(iTextSharp.text.pdf.PdfContentByte cb)
        {
            cb.SetColorFill(iTextSharp.text.BaseColor.BLACK);
            cb.SetColorStroke(iTextSharp.text.BaseColor.BLACK);
            cb.SetLineWidth(1);
            cb.MoveTo(25, 295);//外框線
            cb.LineTo(503, 295);
            cb.LineTo(503, 20);
            cb.LineTo(25, 20);
            cb.LineTo(25, 295);

            cb.MoveTo(25, 275);//內框線(橫上)
            cb.LineTo(503, 275);

            cb.MoveTo(150, 295);//內框線(直)
            cb.LineTo(150, 175);
            cb.MoveTo(225, 295);
            cb.LineTo(225, 175);
            cb.MoveTo(300, 295);
            cb.LineTo(300, 70);
            cb.MoveTo(375, 295);
            cb.LineTo(375, 20);

            cb.MoveTo(70, 150);
            cb.LineTo(70, 95);

            cb.MoveTo(109, 150);
            cb.LineTo(109, 95);

            cb.MoveTo(148, 150);
            cb.LineTo(148, 95);

            cb.MoveTo(187, 150);
            cb.LineTo(187, 95);

            cb.MoveTo(226, 150);
            cb.LineTo(226, 95);

            cb.MoveTo(265, 150);
            cb.LineTo(265, 95);

            cb.MoveTo(25, 175);//內框線(橫下)
            cb.LineTo(503, 175);
            cb.MoveTo(25, 150);
            cb.LineTo(503, 150);

            cb.MoveTo(25, 95);
            cb.LineTo(375, 95);

            cb.MoveTo(25, 70);
            cb.LineTo(375, 70);
            cb.Stroke();
        }
        public void inputTitle(iTextSharp.text.pdf.PdfContentByte cb ,ArrayList vccLabel,int page)
        {
            iTextSharp.text.pdf.BaseFont bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            cb.BeginText();
            cb.SetFontAndSize(bfChinese, 14);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "電子發票證明聯", 210, 425, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)vccLabel[0]).datea, 225, 405, 0);
            cb.SetFontAndSize(bfChinese, 10);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "發票號碼:" + ((Para)vccLabel[0]).invono, 25, 380, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "格    式:25", 450, 380, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "買方:" + ((Para)vccLabel[0]).cust, 25, 355, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "統一編號:" + ((Para)vccLabel[0]).serial, 25, 330, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "地址:" + ((Para)vccLabel[0]).addr, 25, 305, 0);
            if (vccLabel.Count <= 6)
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, "第1頁/共1頁", 503, 305, 0);
            else if (vccLabel.Count > 6 && vccLabel.Count % 6 != 0)
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, "第" + page + "頁/" + "共" + ((vccLabel.Count / 6) + 1) + "頁", 503, 305, 0);
            else if (vccLabel.Count > 6 && vccLabel.Count % 6 == 0)
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, "第" + page + "頁/" + "共" + (vccLabel.Count / 6) + "頁", 503, 305, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "品名", 75, 280, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "數量", 175, 280, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "金額", 325, 280, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "單價", 250, 280, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "備註", 425, 280, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "銷售量合計", 30, 158, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Para)vccLabel[0]).total2.ToString(), 370, 160, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "營業稅", 31, 120, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "應稅", 80, 120, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "√", 119, 120, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "零稅率", 153, 120, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "免稅", 236, 120, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Para)vccLabel[0]).total3.ToString(), 370, 120, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "總計", 30, 80, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Para)vccLabel[0]).total4.ToString(), 370, 80, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "營業人蓋統一發票專用章", 385, 160, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "總計新台幣(中文大寫)", 30, 42, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ConvertInt(((Para)vccLabel[0]).total4.ToString()), 370, 42, 0);
            if (((Para)vccLabel[0]).comp.Length > 10)
            {
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "賣方:" + ((Para)vccLabel[0]).comp.Substring(0, 10), 378, 138, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)vccLabel[0]).comp.Substring(10, ((Para)vccLabel[0]).comp.Length - 10), 378, 128, 0);
            }
            else
            {
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "賣方:" + ((Para)vccLabel[0]).comp, 378, 138, 0);
            }
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "統一編號:" + ((Para)vccLabel[0]).comp_serial, 378, 115, 0);
            if (((Para)vccLabel[0]).comp_addr.Length > 10)
            {
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "地址:" + ((Para)vccLabel[0]).comp_addr.Substring(0, 10), 378, 90, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)vccLabel[0]).comp_addr.Substring(10, ((Para)vccLabel[0]).comp_addr.Length - 10), 378, 80, 0);
            }
            else
            {
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "地址:" + ((Para)vccLabel[0]).comp_addr, 378, 90, 0);
            }
            cb.EndText();
        }
        
		private static string[] cstr = { "零", "壹", "貳", "叁", "肆", "伍", "陸", "柒", "捌", "玖" };
        private static string[] wstr = { "", "", "拾", "佰", "仟", "萬", "拾", "佰", "仟", "億", "拾", "佰", "仟" };
        public string ConvertInt(string str)
        {
            int len = str.Length;

            int i;

            string tmpstr, rstr;

            rstr = "";

            for (i = 1; i <= len; i++)
            {

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
        public void Page_Load()
        {
        	string db = "st";
        	if(Request.QueryString["db"] !=null && Request.QueryString["db"].Length>0)
        	db= Request.QueryString["db"];
        	connectionString = "Data Source=127.0.0.1,1799;Persist Security Info=True;User ID=sa;Password=artsql963;Database="+db;

			var item = new ParaIn();
			if (Request.QueryString["noa"] != null && Request.QueryString["noa"].Length > 0)
            {
                item.noa = Request.QueryString["noa"];
            }
            if (Request.QueryString["noq"] != null && Request.QueryString["noq"].Length > 0)
            {
                item.noq = Request.QueryString["noq"];
            }
            if (Request.QueryString["acomp"] != null && Request.QueryString["acomp"].Length > 0)
            {
                item.acomp = Request.QueryString["acomp"];
            }
            //item.noa = "D1050729001";
            
            //資料
            System.Data.DataTable dt = new System.Data.DataTable();
            using (System.Data.SqlClient.SqlConnection connSource = new System.Data.SqlClient.SqlConnection(connectionString))
            {
                System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter();
                connSource.Open();
                string queryString = @"
		            		            declare @tmp table(
		            accy nvarchar(10),
		            noa nvarchar(200),
		            noq nvarchar(100),
		   			datea nvarchar(30),
					
					invono nvarchar(50),
					cust nvarchar(300),
					serial nvarchar(50),
					addr nvarchar(300),
					product nvarchar(300),
					mount float,
					price float, --單價
					total float, --金額
					memo nvarchar(300),
					
					total2 float,
					total3 float,
					total4 float,
					
					comp nvarchar(300),
					comp_serial nvarchar(50),
					comp_addr nvarchar(300)
				)
				insert into @tmp(noa,noq,datea,invono,cust,serial,addr,product,mount,price,total,memo,comp,comp_serial,comp_addr,total3)
				select b.noa,b.noq,a.datea,a.noa,a.comp,a.serial,c.addr_comp,b.product,b.mount,b.price,b.money,a.memo,e.acomp,e.serial,e.addr,a.tax
				from vcca a
				left join vccas b on a.noa = b.noa
				left join cust c on a.custno = c.noa
				left join acomp e on a.cno = e.noa
				where a.noa=@t_noa
   				and (len(@t_noq)=0 or b.noq=@t_noq)
				
				update a set a.total2 = b.total
				from @tmp a
				outer apply (select SUM(total) as total,noa from @tmp where noa=a.noa group by noa)b
				
				update @tmp set total4 = ROUND(total2+total3,0)
				select * from @tmp";
				
                System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(queryString, connSource);
                cmd.Parameters.AddWithValue("@t_noa", item.noa);
                cmd.Parameters.AddWithValue("@t_noq", item.noq);
                adapter.SelectCommand = cmd;
                adapter.Fill(dt);
                connSource.Close();
            }
            ArrayList vccLabel = new ArrayList();
            foreach (System.Data.DataRow r in dt.Rows)
            {
                
                Para pa = new Para();
                pa.accy = System.DBNull.Value.Equals(r.ItemArray[0]) ? "" : (System.String)r.ItemArray[0];
                pa.noa = System.DBNull.Value.Equals(r.ItemArray[1]) ? "" : (System.String)r.ItemArray[1];
                pa.noq = System.DBNull.Value.Equals(r.ItemArray[2]) ? "" : (System.String)r.ItemArray[2];
                pa.datea = System.DBNull.Value.Equals(r.ItemArray[3]) ? "" : (System.String)r.ItemArray[3];
                pa.invono = System.DBNull.Value.Equals(r.ItemArray[4]) ? "" : (System.String)r.ItemArray[4];
                pa.cust = System.DBNull.Value.Equals(r.ItemArray[5]) ? "" : (System.String)r.ItemArray[5];
                pa.serial = System.DBNull.Value.Equals(r.ItemArray[6]) ? "" : (System.String)r.ItemArray[6];
                pa.addr = System.DBNull.Value.Equals(r.ItemArray[7]) ? "" : (System.String)r.ItemArray[7];
                pa.product = System.DBNull.Value.Equals(r.ItemArray[8]) ? "" : (System.String)r.ItemArray[8];
                pa.mount = System.DBNull.Value.Equals(r.ItemArray[9]) ? 0 : (float)(System.Double)r.ItemArray[9];
                pa.price = System.DBNull.Value.Equals(r.ItemArray[10]) ? 0 : (float)(System.Double)r.ItemArray[10];
                pa.total = System.DBNull.Value.Equals(r.ItemArray[11]) ? 0 : (float)(System.Double)r.ItemArray[11];
                pa.memo = System.DBNull.Value.Equals(r.ItemArray[12]) ? "" : (System.String)r.ItemArray[12];
                pa.total2 = System.DBNull.Value.Equals(r.ItemArray[13]) ? 0 : (float)(System.Double)r.ItemArray[13];
                pa.total3 = System.DBNull.Value.Equals(r.ItemArray[14]) ? 0 : (float)(System.Double)r.ItemArray[14];
                pa.total4 = System.DBNull.Value.Equals(r.ItemArray[15]) ? 0 : (float)(System.Double)r.ItemArray[15];
                pa.comp = System.DBNull.Value.Equals(r.ItemArray[16]) ? "" : (System.String)r.ItemArray[16];
                pa.comp_serial = System.DBNull.Value.Equals(r.ItemArray[17]) ? "" : (System.String)r.ItemArray[17];
                pa.comp_addr = System.DBNull.Value.Equals(r.ItemArray[18]) ? "" : (System.String)r.ItemArray[18];
                vccLabel.Add(pa);
            }
            //-----PDF--------------------------------------------------------------------------------------------------
            var doc1 = new iTextSharp.text.Document(new iTextSharp.text.Rectangle(525, 450), 0, 0, 0, 0);
            iTextSharp.text.pdf.PdfWriter pdfWriter = iTextSharp.text.pdf.PdfWriter.GetInstance(doc1, stream);
            //font
            iTextSharp.text.pdf.BaseFont bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            iTextSharp.text.pdf.BaseFont bfNumber = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\ariblk.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            
            doc1.Open();
            iTextSharp.text.pdf.PdfContentByte cb = pdfWriter.DirectContent;
            if (vccLabel.Count == 0)
            {
                cb.SetColorFill(iTextSharp.text.BaseColor.RED);
                cb.BeginText();
                cb.SetFontAndSize(bfChinese, 30);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "無資料", 20, 20, 0);
                cb.EndText();
            }
            else
            {
                for (int i = 0,y=260,page=1; i < vccLabel.Count; i++,y-=15)
                {
                    if (i == 0)
                    {
                        drawLine(cb);
                        inputTitle(cb,vccLabel,page);
                    }
                    if (i >= 6 && i % 6 == 0)
                    {
                        doc1.NewPage();
                        page++;
                        y = 260;
                        drawLine(cb);
                        inputTitle(cb, vccLabel,page);
                    }
                    //TEXT
                    cb.BeginText();
                    cb.SetFontAndSize(bfChinese, 10);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)vccLabel[i]).product, 30, y, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Para)vccLabel[i]).mount.ToString(), 210, y, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Para)vccLabel[i]).price.ToString(), 290, y, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Para)vccLabel[i]).total.ToString(), 370, y, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)vccLabel[i]).memo, 380, y, 0);
                    cb.EndText();
                }
            }
            doc1.Close();
            Response.ContentType = "application/octec-stream;";
            Response.AddHeader("Content-transfer-encoding", "binary");
            Response.AddHeader("Content-Disposition", "attachment;filename=invo2_" + item.noa + ".pdf");
            Response.BinaryWrite(stream.ToArray());
            Response.End();
        }
    </script>