<%@ Page Language="C#" Debug="true"%>
    <script language="c#" runat="server">     
    	//電子發票證明聯
        System.IO.MemoryStream stream = new System.IO.MemoryStream();
        string connectionString = "";

        public class Bbm
        {
            public string invoiceNumber;
		    public string buyer,buyerId,buyerAddr;
		    public bool istax,zerotax,notax;
		    public decimal money,tax,total;
            public string amountinwords;
            public string seller, sellerId, sellerAddr;
            public string cmoney, ctax, ctotal;
            
            public Bbs[] bbs;
        }
        public class Bbs
        {
            public string product;
            public decimal mount, price, money;
            public string memo;
            public string cmount, cprice, cmoney;
        } 
        
        public void Page_Load()
        {
            string binvono = "", einvono = "";
            string db = "st";
            if (Request.QueryString["db"] != null && Request.QueryString["db"].Length > 0)
                db = Request.QueryString["db"];
            connectionString = "Data Source=127.0.0.1,1799;Persist Security Info=True;User ID=sa;Password=artsql963;Database=" + db;
            if (Request.QueryString["binvono"] != null && Request.QueryString["binvono"].Length > 0)
            {
                binvono = Request.QueryString["binvono"];
            }
            if (Request.QueryString["einvono"] != null && Request.QueryString["einvono"].Length > 0)
            {
                einvono = Request.QueryString["einvono"];
            }
            //資料
            System.Data.DataSet ds = new System.Data.DataSet();
            using (System.Data.SqlClient.SqlConnection connSource = new System.Data.SqlClient.SqlConnection(connectionString))
            {
                System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter();
                connSource.Open();
                string queryString =
                    @"-- BBM
	declare @bbm table(
		invoiceNumber nvarchar(20)
		,buyer nvarchar(max)
		,buyerId nvarchar(20)
		,buyerAddr nvarchar(max)
		,istax bit
		,zerotax bit
		,notax bit
		,[money] decimal(15,7)
		,tax decimal(15,7)
		,total decimal(15,7)
		,xtotal nvarchar(max)
		,seller nvarchar(max)
		,sellerId nvarchar(20)
		,sellerAddr nvarchar(max)
        ,cmoney nvarchar(max)
        ,ctax nvarchar(max)
        ,ctotal nvarchar(max)
        ,bbscount int
	)
	insert into @bbm(invoiceNumber
		,buyer,buyerId,buyerAddr
		,istax,zerotax,notax
		,[money],tax,total,xtotal
		,seller,sellerId,sellerAddr
        ,[cmoney],ctax,ctotal)
	select a.noa
		,case when len(isnull(a.buyer,''))>0 then a.buyer else a.comp end
		,a.serial
		,a.[address] 
		,case a.taxtype when '1' then 1 else 0 end
		,case a.taxtype when '2' then 1 else 0 end
		,case a.taxtype when '4' then 1 else 0 end 
		,a.[money],a.tax,a.total,dbo.AmountInWords(a.total)
		,b.acomp
		,b.serial
		,b.addr_invo
        ,dbo.getComma(a.[money],-1),dbo.getComma(a.[tax],-1),dbo.getComma(a.[total],-1)
	from vcca a
	left join acomp b on a.cno=b.noa
	where a.noa between @binvono and @einvono

    update @bbm set bbscount = isnull(b.n,0)
    from @bbm a
    outer apply(select count(1) n from vccas where noa=a.invoiceNumber) b 
	-- BBS
	declare @bbs table(
        invoiceNumber nvarchar(20)
		,product nvarchar(max)
		,mount decimal(15,7)
		,price decimal(15,7)
		,[money] decimal(15,7)
		,memo nvarchar(max)
        ,cmount nvarchar(max)
        ,cprice nvarchar(max)
        ,cmoney nvarchar(max)
	)
	insert into @bbs(invoiceNumber,product,mount,price,[money],memo,cmount,cprice,cmoney)
	select noa,product,mount,price,[money],memo,dbo.getComma(mount,-1),dbo.getComma(price,-1),dbo.getComma([money],-1)
	from vccas 
	where noa between @binvono and @einvono
	order by noq
	
	select * from @bbm
	select * from @bbs";

                System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(queryString, connSource);
                cmd.Parameters.AddWithValue("@binvono", binvono);
                cmd.Parameters.AddWithValue("@einvono", einvono);
                adapter.SelectCommand = cmd;
                adapter.Fill(ds);
                connSource.Close();
            }

            Bbm[] bbm = new Bbm[ds.Tables[0].Rows.Count];
            
            int n = 0;
            foreach (System.Data.DataRow r in ds.Tables[0].Rows)
            {
                bbm[n] = new Bbm();
                bbm[n].invoiceNumber = System.DBNull.Value.Equals(r.ItemArray[0]) ? "" : (System.String)r.ItemArray[0];
                bbm[n].buyer = System.DBNull.Value.Equals(r.ItemArray[1]) ? "" : (System.String)r.ItemArray[1];
                bbm[n].buyerId = System.DBNull.Value.Equals(r.ItemArray[2]) ? "" : (System.String)r.ItemArray[2];
                bbm[n].buyerAddr = System.DBNull.Value.Equals(r.ItemArray[3]) ? "" : (System.String)r.ItemArray[3]; 
                bbm[n].istax = System.DBNull.Value.Equals(r.ItemArray[4]) ? false : (System.Boolean)r.ItemArray[4];
                bbm[n].zerotax = System.DBNull.Value.Equals(r.ItemArray[5]) ? false : (System.Boolean)r.ItemArray[5];
                bbm[n].notax = System.DBNull.Value.Equals(r.ItemArray[6]) ? false : (System.Boolean)r.ItemArray[6]; 
                bbm[n].money = System.DBNull.Value.Equals(r.ItemArray[7]) ? 0 : (System.Decimal)r.ItemArray[7];
                bbm[n].tax = System.DBNull.Value.Equals(r.ItemArray[8]) ? 0 : (System.Decimal)r.ItemArray[8];
                bbm[n].total = System.DBNull.Value.Equals(r.ItemArray[9]) ? 0 : (System.Decimal)r.ItemArray[9];
                bbm[n].amountinwords = System.DBNull.Value.Equals(r.ItemArray[10]) ? "" : (System.String)r.ItemArray[10];
                bbm[n].seller = System.DBNull.Value.Equals(r.ItemArray[11]) ? "" : (System.String)r.ItemArray[11];
                bbm[n].sellerId = System.DBNull.Value.Equals(r.ItemArray[12]) ? "" : (System.String)r.ItemArray[12];
                bbm[n].sellerAddr = System.DBNull.Value.Equals(r.ItemArray[13]) ? "" : (System.String)r.ItemArray[13];
                bbm[n].cmoney = System.DBNull.Value.Equals(r.ItemArray[14]) ? "" : (System.String)r.ItemArray[14];
                bbm[n].ctax = System.DBNull.Value.Equals(r.ItemArray[15]) ? "" : (System.String)r.ItemArray[15];
                bbm[n].ctotal = System.DBNull.Value.Equals(r.ItemArray[16]) ? "" : (System.String)r.ItemArray[16];

                bbm[n].bbs = new Bbs[System.DBNull.Value.Equals(r.ItemArray[17]) ? 0 : (System.Int32)r.ItemArray[17]];
                int i = 0;
                foreach (System.Data.DataRow s in ds.Tables[1].Rows)
                {
                    if (bbm[n].invoiceNumber != (System.DBNull.Value.Equals(s.ItemArray[0]) ? "" : (System.String)s.ItemArray[0]))
                        continue;
                    bbm[n].bbs[i] = new Bbs();
                    bbm[n].bbs[i].product = System.DBNull.Value.Equals(s.ItemArray[1]) ? "" : (System.String)s.ItemArray[1];
                    bbm[n].bbs[i].mount = System.DBNull.Value.Equals(s.ItemArray[2]) ? 0 : (System.Decimal)s.ItemArray[2];
                    bbm[n].bbs[i].price = System.DBNull.Value.Equals(s.ItemArray[3]) ? 0 : (System.Decimal)s.ItemArray[3];
                    bbm[n].bbs[i].money = System.DBNull.Value.Equals(s.ItemArray[4]) ? 0 : (System.Decimal)s.ItemArray[4];
                    bbm[n].bbs[i].memo = System.DBNull.Value.Equals(s.ItemArray[5]) ? "" : (System.String)s.ItemArray[5];
                    bbm[n].bbs[i].cmount = System.DBNull.Value.Equals(s.ItemArray[6]) ? "" : (System.String)s.ItemArray[6];
                    bbm[n].bbs[i].cprice = System.DBNull.Value.Equals(s.ItemArray[7]) ? "" : (System.String)s.ItemArray[7];
                    bbm[n].bbs[i].cmoney = System.DBNull.Value.Equals(s.ItemArray[8]) ? "" : (System.String)s.ItemArray[8];
                    i++;
                }
                n++;
            }
            //-----PDF--------------------------------------------------------------------------------------------------
            var doc1 = new iTextSharp.text.Document(iTextSharp.text.PageSize.LETTER);
            float width = doc1.PageSize.Width;
            float height = doc1.PageSize.Height / (float)2;
            doc1 = new iTextSharp.text.Document(new iTextSharp.text.Rectangle(width, height), 0, 0, 0, 0);
            doc1.SetMargins(0, 0, 0, 0);

            iTextSharp.text.pdf.PdfWriter pdfWriter = iTextSharp.text.pdf.PdfWriter.GetInstance(doc1, stream);
            //font
            iTextSharp.text.pdf.BaseFont bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            iTextSharp.text.pdf.BaseFont bold = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjhbd.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            iTextSharp.text.pdf.BaseFont bfNumber = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\ariblk.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);

            doc1.Open();
            iTextSharp.text.pdf.PdfContentByte cb = pdfWriter.DirectContent;
            for (n = 0; n < bbm.Length; n++)
            {
                doc1.NewPage();
                //============ 第一頁 ==============
                cb.BeginText();
                cb.SetColorFill(iTextSharp.text.BaseColor.BLACK);
                cb.SetFontAndSize(bfChinese, 12);
                //發票號碼(左: 3.3cm, 高: 11.5cm)
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, bbm[n].invoiceNumber, width / (float)21.59 * (float)3.3, height / (float)13.97 * (float)11.5, 0);
                //買方(左: 3.3cm, 高: 10.8cm)
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, bbm[n].buyer, width / (float)21.59 * (float)3.3, height / (float)13.97 * (float)10.8, 0);
                //統一編號(左: 3.3cm, 高: 10.2cm)
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, bbm[n].buyerId, width / (float)21.59 * (float)3.3, height / (float)13.97 * (float)10.1, 0);
                //地址(左: 3.3cm, 高: 9.5cm)
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, bbm[n].buyerAddr, width / (float)21.59 * (float)3.3, height / (float)13.97 * (float)9.5, 0);

                //BBS   明細最多印5行  8.5 - 4.5 = 4 ,上下保留 1mm, 每行0.8cm
                float h;
                for (int i = 0; i < bbm[n].bbs.Length && i < 5; i++)
                {
                    // 0.2CM微調
                    h = height / (float)13.97 * (float)(4.5 + 0.1 + (4 - i) * 0.8);
                    //品名 L   1.2cm
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, bbm[n].bbs[i].product, width / (float)21.59 * (float)1.2, h, 0);
                    //數量 R 10.7cm
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, bbm[n].bbs[i].cmount, width / (float)21.59 * (float)10.7, h, 0);
                    //單價 R 12.6cm
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, bbm[n].bbs[i].cprice, width / (float)21.59 * (float)12.6, h, 0);
                    //金額 R 15.3cm
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, bbm[n].bbs[i].cmoney, width / (float)21.59 * (float)15.3, h, 0);
                    //備註 L   16cm 
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, bbm[n].bbs[i].memo, width / (float)21.59 * (float)16, h, 0);
                }
                //銷售額合計 R  左:15.2cm 高:3.6cm
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, bbm[n].cmoney, width / (float)21.59 * (float)15.2, height / (float)13.97 * (float)3.6, 0);
                //營業稅 R      左:15.2cm 高:2.9cm
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, bbm[n].ctax, width / (float)21.59 * (float)15.2, height / (float)13.97 * (float)2.9, 0);
                //----- 應稅   C  左:   5.5cm
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, bbm[n].istax ? "V" : "", width / (float)21.59 * (float)5.5, height / (float)13.97 * (float)2.9, 0);
                //----- 零稅率 C  左: 8.7cm
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, bbm[n].zerotax ? "V" : "", width / (float)21.59 * (float)8.7, height / (float)13.97 * (float)2.9, 0);
                //----- 免稅   C  左:11.9cm
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, bbm[n].notax ? "V" : "", width / (float)21.59 * (float)11.9, height / (float)13.97 * (float)2.9, 0);

                //總計 R        左:15.2cm 高:2.2cm
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, bbm[n].ctotal, width / (float)21.59 * (float)15.2, height / (float)13.97 * (float)2.2, 0);
                //金額大寫 L 左:4cm 高:1.2cm
                cb.SetFontAndSize(bfChinese, 14);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, bbm[n].amountinwords, width / (float)21.59 * (float)4, height / (float)13.97 * (float)1.2, 0);

                cb.SetFontAndSize(bfChinese, 8);

                float l = width / (float)21.59 * (float)15.8;
                // 3.5 - 0.7 = 2.8 /4 = 0.7
                //賣方
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "賣　　方：" + bbm[n].seller, l, height / (float)13.97 * (float)2.8, 0);
                //賣方統編
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "統一編號：" + bbm[n].sellerId, l, height / (float)13.97 * (float)2.1, 0);
                //賣方地址
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "地　　址：", l, height / (float)13.97 * (float)1.4, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, bbm[n].sellerAddr, l, height / (float)13.97 * (float)0.8, 0);

                cb.EndText();
            }
         
            // done
            //============ 產品明細 ==============
            /* doc1.NewPage();
             iTextSharp.text.Paragraph pa2 = new iTextSharp.text.Paragraph();
             cb.BeginText();
             //產品明細
             cb.SetFontAndSize(bfChinese, 10);
             cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "產品明細 " + invoice.SellerIdentifier, 18, 110, 0);
             cb.EndText();
             // done
             doc1.Add(pa2);*/
            doc1.Close();
            
            Response.ContentType = "application/octec-stream;";
            Response.AddHeader("Content-transfer-encoding", "binary");
            Response.AddHeader("Content-Disposition", "attachment;filename=" + (binvono==einvono?binvono:binvono+'-'+einvono) + ".pdf");
            Response.BinaryWrite(stream.ToArray());
            Response.End();
        }

      
       
        
		
        
    </script>