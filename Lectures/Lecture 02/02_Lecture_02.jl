### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ 25448e4a-345b-4bd6-9cdb-a6a280cfd22c
# ╠═╡ show_logs = false
#Set-up packages
begin

	#using Pkg
	#Pkg.upgrade_manifest()
	#Pkg.resolve()
	
	using DataFrames, HTTP, CSV, Dates, PlutoUI, Printf, LaTeXStrings, HypertextLiteral, XLSX

	using Plots
	import PlotlyJS
	
	plotlyjs()


	#Define html elements
	nbsp = html"&nbsp" #non-breaking space
	vspace = html"""<div style="margin-bottom:2cm;"></div>"""
	br = html"<br>"

	#Sets the height of displayed tables
	html"""<style>
		pluto-output.scroll_y {
			max-height: 650px; /* changed this from 400 to 550 */
		}
		"""
	
	#Two-column cell
	struct TwoColumn{A, B}
		left::A
		right::B
	end
	
	function Base.show(io, mime::MIME"text/html", tc::TwoColumn)
		write(io,
			"""
			<div style="display: flex;">
				<div style="flex: 50%;">
			""")
		show(io, mime, tc.left)
		write(io,
			"""
				</div>
				<div style="flex: 50%;">
			""")
		show(io, mime, tc.right)
		write(io,
			"""
				</div>
			</div>
		""")
	end

	#Creates a foldable cell
	struct Foldable{C}
		title::String
		content::C
	end
	
	function Base.show(io, mime::MIME"text/html", fld::Foldable)
		write(io,"<details><summary>$(fld.title)</summary><p>")
		show(io, mime, fld.content)
		write(io,"</p></details>")
	end
	
	
	#helper functions
	#round to digits, e.g. 6 digits then prec=1e-6
	roundmult(val, prec) = (inv_prec = 1 / prec; round(val * inv_prec) / inv_prec); 

	using Logging
	global_logger(NullLogger());
	display("")
end

# ╔═╡ a2f22b9d-13f8-4e39-b7dd-14b905d987ab
#add button to trigger presentation mode
html"<button onclick='present()'>present</button>"

# ╔═╡ 731c88b4-7daf-480d-b163-7003a5fbd41f
begin 
	html"""
	<p align=left style="font-size:30px; font-family:family:Georgia"> <b> UD/ISCTE-IUL Trading and Bloomberg Program</b> <p>
	"""
end

# ╔═╡ a5de5746-3df0-45b4-a62c-3daf36f015a5
begin 
	html"""
	<p style="padding-bottom:1cm"> </p>
	<p align=center style="font-size:25px; font-family:family:Georgia"> <b> The U.S. Treasury Market</b> <p>
	<p style="padding-bottom:1cm"> </p>
	<p align=center style="font-size:25px; font-family:family:Georgia"> June 2023 <p>
	<p style="padding-bottom:0.5cm"> </p>
	<div align=center style="font-size:20px; font-family:family:Georgia"> Prof. Matt Fleckenstein </div>
	<p style="padding-bottom:0.05cm"> </p>
	<div align=center style="font-size:20px; font-family:family:Georgia"> University of Delaware, 
	Lerner College of Business and Economics </div>
	<p style="padding-bottom:0cm"> </p>
	"""
end

# ╔═╡ 69dca09e-b572-436f-90c6-187af17cf027
TableOfContents(aside=true, depth=1)

# ╔═╡ 7edf94e7-6096-4cc8-9c3a-d85f40aab75b
vspace

# ╔═╡ 6498b10d-bece-42bf-a32b-631224857753
md"""
# Learning Objectives
"""

# ╔═╡ 95db374b-b10d-4877-a38d-1d0ac45877c4
begin
	html"""
	<fieldset>      
        <legend>Goals for today</legend>      
		<br>
        <input type="checkbox" value="">Know the different types of securities issued by the U.S. Department of the Treasury<br>      
		<br>
<br>
	  	</fieldset>      
	"""
end

# ╔═╡ f655b1ba-d80e-42b1-8552-30d65414aeb0
vspace

# ╔═╡ 6ab6d757-1bcf-4ccd-b7d2-33eba8e7ce81
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 1</div>
"""

# ╔═╡ 10a73b76-b6ad-4081-b8b1-21363608618e
md"""
# The U.S. Treasury Market
- The Department of the Treasury is the largest single issuer of debt in the world.
- The large volume of total debt and the large size of any single issue have contributed to making the Treasury market the most active and hence the most liquid market in the world.


[SIFMA Fixed Income Statistics](https://www.sifma.org/resources/research/fixed-income-chart)
"""

# ╔═╡ 42f7e15d-9abc-40ca-bd70-7131957907a5
md"""
- Why the Treasury Market matters ...
  - [WSJ, February 1, 2022: U.S. National Debt Exceeds $30 Trillion for First Time](https://www.wsj.com/articles/u-s-national-debt-exceeds-30-trillion-for-first-time-11643766231?mod=hp_lead_pos3)
"""

# ╔═╡ c8207eb0-2359-4d62-8f9f-4ff3960b23ee
vspace

# ╔═╡ 71273ef0-b33a-4e77-9510-483fe304b74d
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 2</div>
"""

# ╔═╡ b33e1473-e374-441b-a6a4-6c2a7b079c98
md"""
## U.S. Treasury Debt Amount Outstanding
Year-end data in trillions of dollars. \
_Source: SIFMA_
"""

# ╔═╡ 7bb29c12-c0a0-4eb0-a4d6-bd9c52443751
#Treasury Market Amounts Outstanding
begin
	FI_Out = DataFrame()
	plot_Outstanding = plot()
	let
		file="./US-Fixed-Income-Securities-Statistics-SIFMA.xlsx"
		sheet="Outstanding"
		cols="A:I"
		startrow = 8
		xlsxFile = XLSX.readtable(file, sheet, cols; first_row=startrow, header=true, 			infer_eltypes=true)
		FI_Out = DataFrame(xlsxFile)
				
		catSelect="Treasury"
		#println(catSelect)
		plotData = select(FI_Out, "Year","$(catSelect)")
		rename!(plotData,"Year" => :x, "$(catSelect)" => :y)
		dropmissing!(plotData)
		transform!(plotData, :y => ByRow(x->x/1000), renamecols=false)
		minX = 1975
		maxX = 2025
		minY = 0.0
		maxY = 25.0
		plot!(plot_Outstanding, plotData.x,plotData.y, 
			xlim=(minX,maxX), ylim=(minY, maxY),
			ylabel="Trillions of Dollars",label="$(catSelect)",
			legend = :topleft, title="Amount Outstanding")	
		plot(plot_Outstanding)
	end
end

# ╔═╡ f89f6fc4-cb6f-4d7b-84c9-f8a18e764427
vspace

# ╔═╡ a93b1f32-a12f-42db-be52-8f0365d6cb76
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 3</div>
"""

# ╔═╡ 313959e0-eea6-449a-a6b8-29c9394e50b6
LocalResource("./TreasuryOutstandingSIFMA.png",:width => 900)

# ╔═╡ e20b95fa-e038-4d3b-82ca-8a38262c64c4
md"""
[Link to SIFMA](https://www.sifma.org/resources/research/fixed-income-chart/)
"""

# ╔═╡ 99b2ef18-11bd-40ed-92f6-143b504a036d
vspace

# ╔═╡ 54fc1118-d78b-40f2-bfa9-86a6034006e0
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 4</div>
"""

# ╔═╡ 2bf62523-a0f1-400e-9178-79062e0a171e
md"""
## U.S. Treasury Debt Amount Issued
Annual data at year-end in trillions of dollars.\
_Source: SIFMA_
"""

# ╔═╡ 206df1a6-bf12-4957-93f7-472ee89594c4
#US Treasury Securities Amounts Issued
begin
	FI_Iss = DataFrame()
	plot_Issuance = plot()
	let
		file="./US-Fixed-Income-Securities-Statistics-SIFMA.xlsx"
		sheet="Issuance"
		cols="A:H"
		startrow = 8
		xlsxFile = XLSX.readtable(file, sheet, cols; first_row=startrow, 
			header=true, infer_eltypes=true)
		FI_Iss = DataFrame(xlsxFile)
		
		catSelect="Treasury"
		plotData = select(FI_Iss, "Year","$(catSelect)")
		rename!(plotData,"Year" => :x, "$(catSelect)" => :y)
		dropmissing!(plotData)
		transform!(plotData, :y => ByRow(x->x/1000), renamecols=false)
		minX = 1994
		maxX = 2022
		minY = 0.0
		maxY = 6.0
		plot!(plot_Issuance, plotData.x,plotData.y, 
			xlim=(minX,maxX), ylim=(minY, maxY),
			ylabel="Trillions of Dollars",label="$(catSelect)",
			legend = :topleft, title="Amount Issued")	
		plot(plot_Issuance)
	end
end


# ╔═╡ c8f703dc-5a1c-4c39-b9a4-c3dd0a2806d8
vspace

# ╔═╡ 46aa48e7-eb56-4fa5-aeac-36119b1140a2
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 5</div>
"""

# ╔═╡ 13a58974-2ae8-4596-933f-5d2b5b8f5a23
LocalResource("./TreasuryIssuanceSIFMA.png",:width => 900)

# ╔═╡ e89beeee-1ad9-4440-ba95-9bd0eb6bfe72
md"""
_Note_: Issuance is long-term instruments only.\
[Link to SIFMA](https://www.sifma.org/resources/research/fixed-income-chart/)
"""

# ╔═╡ 84009ee2-cfc3-437c-8782-d370b8b8c4f6
vspace

# ╔═╡ ecf1df36-eb3e-4074-9a36-774a3b6b0f72
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 6</div>
"""

# ╔═╡ a2df8dc1-f6da-4816-85b9-c7caadc03584
#Treasury Market Total Amount Outstanding vs Equity
begin
	
	plot_MktCap = plot()
	let
		file="./MarketCaps.xlsx"
		sheet="Sheet1"
		cols="A:B"
		startrow = 8
		xlsxFile = XLSX.readtable(file, sheet, cols; first_row=startrow, header=false,
			column_labels=["Date","Equity"], infer_eltypes=true)
		EquMktCap = DataFrame(xlsxFile)
		dropmissing!(EquMktCap)
		transform!(EquMktCap,:Equity=>(x->x./1000)=>:Equity, 
			:Date => (x->year.(x)) => :Year,
			:Date => (x->month.(x)) => :Month)
		filter!(:Month => ==(12),EquMktCap)
		MktCaps = leftjoin(EquMktCap,FI_Out[:,[:Year,:Treasury]], on=:Year)
		select!(MktCaps,:Year,:Treasury,:Equity)
		transform!(MktCaps,names(MktCaps,Not(:Year)) .=> (x->x./1000.0),
			renamecols=false)
		minX = minimum(MktCaps.Year)-1
		maxX = maximum(MktCaps.Year)+1
		minY = 0.0
		maxY = 55.0
		plot!(plot_MktCap, MktCaps.Year,MktCaps.Treasury, 
			  xlim=(minX,maxX), ylim=(minY, maxY),
			  ylabel="Trillions of Dollars", label="Fixed Income",
			  legend = :topleft, title="US Treasury vs. Equity Markets")	
		plot!(plot_MktCap, MktCaps.Year,MktCaps."Equity", 
			  label="Equity")	
     	plot(plot_MktCap)
	end
end

# ╔═╡ aa7c586a-dc74-401f-ae85-8ab3a915680a
vspace

# ╔═╡ de202dfb-ddcf-432e-ae47-9639acb35065
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 7</div>
"""

# ╔═╡ 5db80dee-c643-4cc1-bca4-00b1ffd0a948
md"""
## U.S. Treasury Securities Trading Volume
Average Daily Trading Volume. Annual data at year-end in billions of dollars.\
_Source: SIFMA_
"""

# ╔═╡ 0357258e-8133-4ef3-946f-5134a9560b9d
#US Treasury Market Trading Volumes
begin
	FI_Vol = DataFrame()
	plot_Vol = plot()
	let
		file="./US-Fixed-Income-Securities-Statistics-SIFMA.xlsx"
		sheet="Trading Volume"
		cols="A:I"
		startrow = 8
		xlsxFile = XLSX.readtable(file, sheet, cols; first_row=startrow, 
			header=true, infer_eltypes=true)
		FI_Vol = DataFrame(xlsxFile)
		
		catSelect="Treasury"
		plotData = select(FI_Vol, "Year","$(catSelect)")
		rename!(plotData,"Year" => :x, "$(catSelect)" => :y)
		dropmissing!(plotData)
		minX = 1995
		maxX = 2022
		minY = 0.0
		maxY = 650.0
		plot!(plot_Vol, plotData.x,plotData.y, 
			xlim=(minX,maxX), ylim=(minY, maxY),
			ylabel="Billions of Dollars",label="$(catSelect)",
			legend = :topleft, title="Trading Volume")	
		plot(plot_Vol)
	end
end

# ╔═╡ 4c7a13f2-05a9-4069-89ba-4e91a0bdf7db
vspace

# ╔═╡ 284c7ed7-7417-4bda-8a30-04eebd657bd5
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 8</div>
"""

# ╔═╡ ae67f236-60ec-4c2e-abd3-9ea537200ca3
md"""
# Types of Treasury Securities
"""

# ╔═╡ fa1dcebd-4a54-433b-897c-de2929fb8233
md"""
>- Where to get information about U.S. Treasury securities?
>- Go to webpage of the [U.S. Treasury](https://www.treasurydirect.gov/).
>- In the middle panel, click on `Treasury securities Overview`.
"""

# ╔═╡ 00ce1a7e-a0db-4ebb-a2d5-d31e19696d3c
vspace

# ╔═╡ 0a44df3e-a05c-4d6f-9c7e-66695d7f68e3
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 9</div>
"""

# ╔═╡ 2452e56b-2a61-4608-9ca0-55c8cdca89c6
LocalResource("TreasuryDirect_01.png",:width => 900)

# ╔═╡ f688e93c-e8b1-4718-b56e-d76bf70eef57
vspace

# ╔═╡ a9e13bf5-cf0a-46eb-b651-764bf000cad4
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 10</div>
"""

# ╔═╡ 4914c857-5dc8-43b8-8e70-377debbc3d0c
LocalResource("TreasuryDirect_02.png",:width => 900)

# ╔═╡ ef2c8029-5bc9-4229-b321-0d9da728ead1
vspace

# ╔═╡ d0d49aab-5f88-4319-b81b-4e8fc036d1b3
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 11</div>
"""

# ╔═╡ d25744ad-fbe3-4f08-b17a-d00d51bcb2b8
md"""
# Treasury Bill (T-bill)
- Short-term securities with maturities of 4, 13, 26, and 52 weeks.
- Treasury bills do not pay interest before maturity.
  - This is often referred to as a _discount security_ or _zero-coupon security_.
- Instead, Treasury bills are issued at a price less than their par value and at maturity, Treasury bills pay back their par value.
  - Intuitively, the “interest” to the investor is the difference between par value and the purchase price.
  - Example: a 52-week T-bill with par value of \$100 has a price of \$98.
"""

# ╔═╡ f61d7698-b925-467a-9d7a-2430c1d93026
vspace

# ╔═╡ 78231e48-0137-4e25-a149-5c87c92e7b9c
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 12</div>
"""

# ╔═╡ 382a9c58-4baa-4ad2-9f32-7189d4881c50
md"""
## Example of 52-week Treasury Bill
"""

# ╔═╡ deb54591-8769-480d-98ad-32157abac2c0
LocalResource("./BloombergTBill_01.png", :width=>900)

# ╔═╡ 3578793a-e0b6-42de-941b-2db09ef99e49
md"""
>- How to get there on the Bloomberg terminal?
>  - Open a terminal and on the keyboard type `T Bill`.
>  - In the popup window,  select `B Govt - United States Treasury Bill (Multiple Matches)`.
>  - Next, click on one of the different Treasury bills in the list.
>  - Then, click on `DES` on the top-right, or type `DES` on the keyboard and press enter.
"""

# ╔═╡ 82db2847-a1a1-45a3-8d29-c3ac4213591c
vspace

# ╔═╡ 5872c555-5d6d-4f74-ab85-d0a85d2be11d
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 13</div>
"""

# ╔═╡ adbc8a60-c33c-44ba-a284-fa7b676b9618
md"""
- Let's look at price quotes for this Treasury bill.
- If you were to purchase this Treasury bill, would you pay \$0.8450?
- The answer is _no_. Prices for Treasury bills are quoted in a specific way, which we will discuss in the next lecture.
"""

# ╔═╡ 1a6add34-52e1-4663-9228-f0fca63f8cc2
LocalResource("./BloombergTBill_02.png")

# ╔═╡ 8de081f6-2b7f-4d03-b565-b4ac01c2773e
md"""
>- How to get there on the Bloomberg terminal?
>  - From the `Description` page where you are currently at, type `GP` and press enter.
"""

# ╔═╡ 906ed779-494d-442b-b787-a187f69aca9f
vspace

# ╔═╡ 64de511a-bba4-4df2-a9a3-2992d5333bc3
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 14</div>
"""

# ╔═╡ d296b99d-588d-48ac-8e0c-a0bcbde72c56
md"""
# Treasury Note (T-Note)
- Medium-term securities with maturities of 2, 3, 5, 7, and 10 years.
- Treasury notes pay interest every six months up to and including the maturity date.
  - Example: A 2-year T-note has its last interest payment in two years, and it pays interest after 6 months, 12 months, and 18 months.
- At maturity, Treasury notes pay back their par value.
"""

# ╔═╡ 0b29d855-ac09-4342-a7d1-110add543f3c
vspace

# ╔═╡ 27593a90-7d18-4afd-8b0c-701021f23194
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 15</div>
"""

# ╔═╡ 1c4db2fa-7187-4966-aa3f-9a7f56036497
md"""
## Example of 10-year Treasury Note
"""

# ╔═╡ 3a3b7641-ed63-4cce-a98c-a4cf1b6e603d
LocalResource("./BloombergTNote_01.png")

# ╔═╡ 2384b88b-e8dc-4e9c-9488-27828da0289d
md"""
>- How to get there on the Bloomberg terminal?
>  - Open a terminal and on the keyboard type `T Note`.
>  - In the popup window,  select `T Govt - United States Treasury Note/Bond (Multiple Matches)`.
>  - Next, click on one of the different Treasury notes in the list.
>  - Then, click on `DES` on the top-right, or type `DES` on the keyboard and press enter.
"""

# ╔═╡ a13a140d-51b4-43a1-b5e6-7cb5026f9ed8
vspace

# ╔═╡ c5311825-1d43-406c-ac88-094cbc198746
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 16</div>
"""

# ╔═╡ 0918383a-9a0b-4f8c-ba63-aaad1cf6d72c
md"""
- Let's look at price quotes for this Treasury note.
- If you were to purchase this Treasury note, would you pay \$95.02?
- The answer is _no_. Prices for Treasury notes are quoted in a specific way, which we will discuss in the next lecture.
"""

# ╔═╡ c9b876e2-cb29-4a70-9c1f-abb2dedf3fe2
LocalResource("./BloombergTNote_02.png")

# ╔═╡ d912c3cb-c1a6-46fe-af9d-25a75074b31d
md"""
>- How to get there on the Bloomberg terminal?
>  - From the `Description` page where you are currently at, type `GP` and press enter.
"""

# ╔═╡ f3949f40-c3c9-4031-aae9-5954fd3e7e27
vspace

# ╔═╡ 2a701d2c-e526-40a7-93ee-544e5f5b7a7c
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 17</div>
"""

# ╔═╡ 40df1177-48cf-4cb2-9860-11d2d9f0a450
md"""
# Treasury Bond (T-Bond)
- Long-term securities with maturities of 20 and 30 years.
  - Currently, the Treasury does not issue 15-year Treasury bonds.
- Treasury bonds notes pay interest every six months up to and including the maturity date. At maturity, Treasury notes pay back their par value.
  - Similar to Treasury notes.

[Treasury Marketable Securities](https://www.treasurydirect.gov/instit/marketables/marketables.htm)
"""

# ╔═╡ be69c9e5-c610-4317-96f8-4bc1fbd8dd75
vspace

# ╔═╡ 43e1d6ae-bccb-4974-b2d0-a1876228d263
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 18</div>
"""

# ╔═╡ 76774fcb-f806-4db2-b653-fe69720f43a7
md"""
## Coupon bonds
- Treasury notes and bonds are referred to as **coupon** securities.
- Why?
"""

# ╔═╡ a440a28f-04af-4248-8f2b-c8e6a726c07a
LocalResource("TreasuryCouponPicture.svg",:width => 900)

# ╔═╡ e79d1c10-787b-442a-a80b-934c8bb80dd1
vspace

# ╔═╡ 84d6304e-3bb3-431b-9afd-814bea33dd71
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 19</div>
"""

# ╔═╡ fef5577e-025f-4afc-9fd9-aa025146858e
md"""
# Treasury Floating Rate Note (FRN)
- First issued in 2014 by the U.S. Treasury.
- Maturity of 2 years.
- Pay interest every three months up to and including the maturity date.
  - At maturity, FRNs pay back their par value.
- The interest on an FRN varies with interest rate on 13-week Treasury bills.
"""

# ╔═╡ 5760f508-8d91-47ec-9177-fbce8e08462b
vspace

# ╔═╡ bc22c5ed-b8d6-4bf8-a325-78dea3388c11
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 20</div>
"""

# ╔═╡ 90883b07-064f-4395-a805-ddaaad7f97fd
md"""
## Example of Treasury Floating Rate Note (FRN)
"""

# ╔═╡ faecc806-5f33-49c6-a463-b349cbfb8acc
LocalResource("./BloombergFRN_01.png")

# ╔═╡ c7a254a6-d877-4de0-a3e5-a64fb93ae079
md"""
>- How to get there on the Bloomberg terminal?
>  - Open a terminal and on the keyboard type `Treasury Floating Rate Note`.
>  - In the popup window,  select `TF Govt - United States Treasury Floating Rate Note (Multiple Matches)`.
>  - Next, click on one of the different Treasury FRNs in the list.
>  - Then, click on `DES` on the top-right, or type `DES` on the keyboard and press enter.
"""

# ╔═╡ 3cbe2b93-d0a2-429e-8389-9eea20abaa79
vspace

# ╔═╡ 2e818466-ca18-46b4-9072-933debe49523
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 21</div>
"""

# ╔═╡ 9b53686c-e362-46c5-bdd9-0c388d9cd122
LocalResource("./BloombergFRN_02.png")

# ╔═╡ 9d0017a5-6b7b-4c1b-9323-7a8fdc54db77
md"""
- Let's look at the price quote for this Treasury FRN.
- If you were to purchase this Treasury FRN, would you pay \$100.1674?
- Generally, the answer is _no_. Prices for Treasury FRNs are quoted in a specific way, which we will discuss in the next lecture.
"""

# ╔═╡ 69d8c85f-3735-4bd2-bd37-1ddadab87140
md"""
>- How to get there on the Bloomberg terminal?
>  - From the `Description` page where you are currently at, type `GP` and press enter.
"""

# ╔═╡ bc9967a4-ad61-41b5-88ab-5a676beb5637
vspace

# ╔═╡ 1e4bda9a-9265-4692-b056-13637878343f
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 22</div>
"""

# ╔═╡ cf1fa1d8-da24-4f48-8762-affa1f58279a
md"""
# Treasury Inflation Protected Securities (TIPS)
- First issued in 1997 by the U.S. Treasury.
- Maturities of 5, 10, and 30 years.
- TIPS pay interest every six months up to and including the maturity date. At maturity, Treasury notes pay back their par value.
  - Similar to Treasury notes and bonds.
- Key difference is that both par value and interest go up with the rate of inflation.
"""

# ╔═╡ c9e610fb-2bda-4538-8979-267a97d9619c
vspace

# ╔═╡ 0abc165c-17de-4c15-97e1-f9e3506bcd1b
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 23</div>
"""

# ╔═╡ 3000e0f6-381f-4a9c-85c1-c517af617f14
md"""
- Why inflation matters and why one might want to hedge against inflation.
  - [WSJ, January 12, 2022: U.S. Inflation Hit 7% in December, Fastest Pace Since 1982](https://www.wsj.com/articles/us-inflation-consumer-price-index-december-2021-11641940760?mod=article_inline)
  - [WSJ, February 10, 2022: U.S. Inflation Rate Accelerates to a 40-Year High of 7.5%](https://www.wsj.com/articles/us-inflation-consumer-price-index-january-2022-11644452274?mod=hp_lead_pos1)
  - [WSJ, February 6, 2022: What Investors Should Know About TIPS](https://www.wsj.com/articles/tips-what-investors-should-know-treasury-inflation-protected-securities-11643849892?mod=hp_lista_pos1)
"""

# ╔═╡ 085b1908-4421-4f3b-8876-3fe0fd6f805a
vspace

# ╔═╡ 214ef16f-329e-4549-99b9-d6a39724f50a
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 24</div>
"""

# ╔═╡ 5c8f4910-7b54-414a-8eb9-52104c0ff36e
md"""
## Example of a Treasury TIPS
"""

# ╔═╡ 972e44da-4614-4349-bcb7-edb0518fe24d
LocalResource("./BloombergTIPS_01.png")

# ╔═╡ a1c74635-2fb9-492c-8243-4232b771718b
md"""
>- How to get there on the Bloomberg terminal?
>  - Open a terminal and on the keyboard type `Treasury TIPS`.
>  - In the popup window,  select `TII Govt - United States Treasury Inflation Indexed Bonds (Multiple Matches)`.
>  - Next, click on one of the different Treasury bills in the list.
>  - Then, click on `DES` on the top-right, or type `DES` on the keyboard and press enter.
"""

# ╔═╡ 45ffcfef-16f3-464a-b868-0d3f64cb6019
vspace

# ╔═╡ c1e9807b-5428-4ac1-be09-63847c3b5b5e
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 25</div>
"""

# ╔═╡ 874afd1d-eba3-4295-9f96-7502c187b171
md"""
- Let's look at price quotes for this Treasury TIPS.
- If you were to purchase this Treasury TIPS, would you pay \$105.28?
- The answer is _no_. Prices for Treasury TIPS are quoted in a specific way, which we will discuss in the next lecture.
"""

# ╔═╡ 95110a89-1d2b-4c83-9b1c-d7dc95ab89c8
LocalResource("./BloombergTIPS_02.png")

# ╔═╡ aa70d2f6-c726-45cc-89cb-bb6afb85f065
md"""
>- How to get there on the Bloomberg terminal?
>  - From the `Description` page where you are currently at, type `GP` and press enter.
"""

# ╔═╡ cf6ef91d-7ebe-4b64-b7af-61fe6b5b1ff2
vspace

# ╔═╡ 37af6f97-f9c5-4488-bba5-cd1a993a6a08
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 26</div>
"""

# ╔═╡ d69cce2c-dce4-4369-b3db-968c0b4d3dc6
md"""
## Inflation-Linked notes date back centuries
"""

# ╔═╡ ccba5159-b6bb-4c98-8f04-8dd91c032146
md"""
> Both Principal and Interest to be paid in the then current Money of said State, in a greater or less Sum, according as Five Bushels of Corn, Sixty-eight Pounds and four-seventh Parts of a Pound of Beef, Ten Pounds of Sheeps Wool, and Sixteen Pounds of Sole Leather shall then cost more or less than One Hundred and Thirty Pounds current Money, at the then current Prices of said Articles.
_Source: “Inflation-indexed Securities: Bonds, Swaps and Other Derivatives”, 2nd Edition, M. Deacon, A. Derry, D. Mirfendereski, Wiley._


"""

# ╔═╡ f50d144b-6d62-4b3f-b85a-d76861ea2ae0
LocalResource("./SoldiersDepreciationNote.svg",:width => 900)

# ╔═╡ 0f8f4ec6-c3a9-4ca0-a2e6-750714e0ab14
vspace

# ╔═╡ 30e93a80-d035-49f4-852c-040c68a862da
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 27</div>
"""

# ╔═╡ c4aa9ab9-5502-4676-8b6a-5b55cc645e03
md"""
## TIPS Inflation-Adjustment
"""

# ╔═╡ f481451a-6949-4604-811b-6b4c530fd644
LocalResource("./TIPSInflationAdjustment.svg",:width => 900)

# ╔═╡ 00683f9c-6f56-4457-a6eb-a680d7435ed5
vspace

# ╔═╡ 0a51ba4b-2596-433e-ab47-7f3d0d1ad916
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 28</div>
"""

# ╔═╡ 992074c6-d6d5-4417-9edc-0229a0333070
md"""
# Treasury STRIPS

- The Treasury does not issue zero-coupon notes or bonds.
- However, because of the demand for zero-coupon instruments with no credit risk, the private sector has created such securities.
- The process of separating the interest on a bond from the underlying principal is called coupon stripping
- Zero-coupon Treasury securities were first created in August 1982 by large Wall-Street firms.
  - The problem with these securities was that they were identified with particular dealers and therefore reduced liquidity.
  - Moreover, the process involved legal and insurance costs. 
  - Today, all Treasury notes and bonds (fixed-principal and inflation-indexed) are eligible for stripping. 
- The zero-coupon Treasury securities created under the STRIPS program are direct obligations of the U.S. government
"""

# ╔═╡ 093d0720-9acd-4fcf-9822-ed6ced3bdda2
vspace

# ╔═╡ b9da0c02-3246-48b2-8922-91c4e46638f4
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 29</div>
"""

# ╔═╡ cc282e0d-9faa-4808-b506-335e9097f2fe
md"""
## Treasury STRIPS in Bloomberg
"""

# ╔═╡ d44298e3-5763-4249-8140-5eefb80adb49
LocalResource("./TreasurySTRIPSBloomberg.png",:width => 900)

# ╔═╡ 57759a33-f026-4c15-91ba-f6af45627f1e
md"""
>- How to get there on the Bloomberg terminal?
>  - Open a terminal and on the keyboard type `Treasury STRIP`.
>  - In the popup window,  select `S Govt - United States Treasury Strip Coupon (Multiple Matches)`.
>  - Next, click on one of the different Treasury bills in the list.
>  - Then, click on `DES` on the top-right, or type `DES` on the keyboard and press enter.
"""

# ╔═╡ 9c596473-76f6-4e9a-b3dd-32add39eaf92
vspace

# ╔═╡ e17a53b2-23c4-4ae6-aa55-e410fbd88b5a
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 30</div>
"""

# ╔═╡ 9db71771-d778-4d43-af7a-80d8cfff97ff
LocalResource("./BloombergSTRIPS_01.png")

# ╔═╡ 36678746-8926-451d-b692-b57c620170c5
vspace

# ╔═╡ 702d7ff3-e641-4a2b-a8ec-0f1cc0f2ba71
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 31</div>
"""

# ╔═╡ 8f65e51f-01d6-4d02-bee2-f7d16f62a6c2
md"""
- Let's look at price quotes for this Treasury STRIPS.
"""

# ╔═╡ e16d631b-befe-4657-ad03-e65b5999e49a
LocalResource("./BloombergSTRIPS_02.png")

# ╔═╡ cb095719-ba0a-49e4-8cb4-fbf28e63c012
vspace

# ╔═╡ 96b74c6d-5d6e-4c91-8bd2-6eec2fedf308
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 32</div>
"""

# ╔═╡ 53c77ef1-899d-47c8-8a30-ea38380d1614
md"""
## Wrap-Up
"""

# ╔═╡ 670e45a3-9d28-47ae-a6b6-a1b1c67a0a4c
begin
	html"""
	<fieldset>      
        <legend>Our goals for today</legend>      
		<br>
        <input type="checkbox" value="" checked>Know the different types of securities issued by the U.S. Department of the Treasury<br>      
<br>
<br>
	  	</fieldset>      
	"""
end

# ╔═╡ e4f05023-5e88-4d5d-a74a-83f25a84b6b2
vspace

# ╔═╡ 2ee2c328-5ebe-488e-94a9-2fce2200484c
md"""
# Reading 
Fabozzi, Fabozzi, 2021, Bond Markets, Analysis, and Strategies, 10th Edition\
Chapter 7
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
HTTP = "cd3eb016-35fb-5094-929b-558a96fad6f3"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Logging = "56ddb016-857b-54e1-b83d-db4d58db5568"
PlotlyJS = "f0f68f2c-4968-5e81-91da-67840de0976a"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"
XLSX = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"

[compat]
CSV = "~0.10.7"
DataFrames = "~1.4.3"
HTTP = "~0.9.17"
HypertextLiteral = "~0.9.4"
LaTeXStrings = "~1.3.0"
PlotlyJS = "~0.18.10"
Plots = "~1.36.6"
PlutoUI = "~0.7.48"
XLSX = "~0.8.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[AssetRegistry]]
deps = ["Distributed", "JSON", "Pidfile", "SHA", "Test"]
git-tree-sha1 = "b25e88db7944f98789130d7b503276bc34bc098e"
uuid = "bf4720bc-e11a-5d0c-854e-bdca1663c893"
version = "0.1.0"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BinDeps]]
deps = ["Libdl", "Pkg", "SHA", "URIParser", "Unicode"]
git-tree-sha1 = "1289b57e8cf019aede076edab0587eb9644175bd"
uuid = "9e28174c-4ba2-5203-b857-d8d62c4213ee"
version = "1.0.2"

[[Blink]]
deps = ["Base64", "BinDeps", "Distributed", "JSExpr", "JSON", "Lazy", "Logging", "MacroTools", "Mustache", "Mux", "Reexport", "Sockets", "WebIO", "WebSockets"]
git-tree-sha1 = "08d0b679fd7caa49e2bca9214b131289e19808c0"
uuid = "ad839575-38b3-5650-b840-f874b8c74a25"
version = "0.12.5"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings"]
git-tree-sha1 = "c5fd7cd27ac4aed0acf4b73948f0110ff2a854b2"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.7"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e7ff6cadf743c098e08fca25c91103ee4303c9bb"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.6"

[[ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random", "SnoopPrecompile"]
git-tree-sha1 = "aa3edc8f8dea6cbfa176ee12f7c2fc82f0608ed3"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.20.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "aaabba4ce1b7f8a9b34c015053d3b1edf60fa49c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.4.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[DataAPI]]
git-tree-sha1 = "e08915633fcb3ea83bf9d6126292e5bc5c739922"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.13.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SnoopPrecompile", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "0f44494fe4271cc966ac4fea524111bef63ba86c"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.4.3"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "c36550cb29cbe373e95b3f40486b9a4148f89ffd"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.2"

[[Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[EzXML]]
deps = ["Printf", "XML2_jll"]
git-tree-sha1 = "0fa3b52a04a4e210aeb1626def9c90df3ae65268"
uuid = "8f5d6c58-4d21-5cfd-889c-e3ad7ee6a615"
version = "1.1.0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "e27c4ebe80e8699540f2d6c805cc12203b614f12"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.20"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[FunctionalCollections]]
deps = ["Test"]
git-tree-sha1 = "04cb9cfaa6ba5311973994fe3496ddec19b6292a"
uuid = "de31a74c-ac4f-5751-b3fd-e18cd04993ca"
version = "0.5.0"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "051072ff2accc6e0e87b708ddee39b18aa04a0bc"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.71.1"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "501a4bf76fd679e7fcd678725d5072177392e756"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.71.1+0"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[Hiccup]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "6187bb2d5fcbb2007c39e7ac53308b0d371124bd"
uuid = "9fb69e20-1954-56bb-a84f-559cc56a8ff7"
version = "0.2.2"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "0cf92ec945125946352f3d46c96976ab972bde6f"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.3.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[JSExpr]]
deps = ["JSON", "MacroTools", "Observables", "WebIO"]
git-tree-sha1 = "b413a73785b98474d8af24fd4c8a975e31df3658"
uuid = "97c1335a-c9c5-57fe-bc5d-ec35cebe8660"
version = "0.5.4"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[Kaleido_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "43032da5832754f58d14a91ffbe86d5f176acda9"
uuid = "f7e6163d-2fa5-5f23-b69c-1db539e41963"
version = "0.2.1+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "ab9aa169d2160129beb241cb2750ca499b4e90e9"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.17"

[[Lazy]]
deps = ["MacroTools"]
git-tree-sha1 = "1370f8202dac30758f3c345f9909b97f53d87d3f"
uuid = "50d2b5c4-7a5e-59d5-8109-a42b560f39c0"
version = "0.15.1"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "946607f84feb96220f480e0422d3484c49c00239"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.19"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[Mustache]]
deps = ["Printf", "Tables"]
git-tree-sha1 = "1e566ae913a57d0062ff1af54d2697b9344b99cd"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.14"

[[Mux]]
deps = ["AssetRegistry", "Base64", "HTTP", "Hiccup", "Pkg", "Sockets", "WebSockets"]
git-tree-sha1 = "82dfb2cead9895e10ee1b0ca37a01088456c4364"
uuid = "a975b10e-0019-58db-a62f-e48ff68538c9"
version = "0.7.6"

[[NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[Observables]]
git-tree-sha1 = "6862738f9796b3edc1c09d0890afce4eca9e7e93"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.4"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6e9dba33f9f2c44e08a020b0caf6903be540004"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.19+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "b64719e8b4504983c7fca6cc9db3ebc8acc2a4d6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.1"

[[Pidfile]]
deps = ["FileWatching", "Test"]
git-tree-sha1 = "2d8aaf8ee10df53d0dfb9b8ee44ae7c04ced2b03"
uuid = "fa939f87-e72e-5be4-a000-7fc836dbe307"
version = "1.3.0"

[[Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "21303256d239f6b484977314674aef4bb1fe4420"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.1"

[[PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "56baf69781fc5e61607c3e46227ab17f7040ffa2"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.19"

[[PlotlyJS]]
deps = ["Base64", "Blink", "DelimitedFiles", "JSExpr", "JSON", "Kaleido_jll", "Markdown", "Pkg", "PlotlyBase", "REPL", "Reexport", "Requires", "WebIO"]
git-tree-sha1 = "7452869933cd5af22f59557390674e8679ab2338"
uuid = "f0f68f2c-4968-5e81-91da-67840de0976a"
version = "0.18.10"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SnoopPrecompile", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "6a9521b955b816aa500462951aa67f3e4467248a"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.36.6"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "efc140104e6d0ae3e7e30d56c98c4a927154d684"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.48"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "LaTeXStrings", "Markdown", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "d8ed354439950b34ab04ff8f3dfd49e11bc6c94b"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.2.1"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "d12e612bba40d189cead6ff857ddb67bd2e6a387"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.1"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase", "SnoopPrecompile"]
git-tree-sha1 = "e974477be88cb5e3040009f3767611bc6357846f"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.11"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "efd23b378ea5f2db53a55ae53d3133de4e080aa9"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.16"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[StringManipulation]]
git-tree-sha1 = "46da2434b41f41ac3594ee9816ce5541c6096123"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.0"

[[SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "c79322d36826aa2f4fd8ecfa96ddb47b174ac78d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "8a75929dcd3c38611db2f8d08546decb514fcadf"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.9"

[[Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[URIParser]]
deps = ["Unicode"]
git-tree-sha1 = "53a9f49546b8d2dd2e688d216421d050c9a31d0d"
uuid = "30578b45-9adc-5946-b283-645ec420af67"
version = "0.4.1"

[[URIs]]
git-tree-sha1 = "ac00576f90d8a259f2c9d823e91d1de3fd44d348"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.1"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[WebIO]]
deps = ["AssetRegistry", "Base64", "Distributed", "FunctionalCollections", "JSON", "Logging", "Observables", "Pkg", "Random", "Requires", "Sockets", "UUIDs", "WebSockets", "Widgets"]
git-tree-sha1 = "55ea1b43214edb1f6a228105a219c6e84f1f5533"
uuid = "0f1e0344-ec1d-5b48-a673-e5cf874b6c29"
version = "0.8.19"

[[WebSockets]]
deps = ["Base64", "Dates", "HTTP", "Logging", "Sockets"]
git-tree-sha1 = "f91a602e25fe6b89afc93cf02a4ae18ee9384ce3"
uuid = "104b5d7c-a370-577a-8038-80a2059c5097"
version = "1.5.9"

[[Widgets]]
deps = ["Colors", "Dates", "Observables", "OrderedCollections"]
git-tree-sha1 = "fcdae142c1cfc7d89de2d11e08721d0f2f86c98a"
uuid = "cc8bc4a8-27d6-5769-a93b-9d913e69aa62"
version = "0.6.6"

[[XLSX]]
deps = ["Artifacts", "Dates", "EzXML", "Printf", "Tables", "ZipFile"]
git-tree-sha1 = "ccd1adf7d0b22f762e1058a8d73677e7bd2a7274"
uuid = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"
version = "0.8.4"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[ZipFile]]
deps = ["Libdl", "Printf", "Zlib_jll"]
git-tree-sha1 = "f492b7fe1698e623024e873244f10d89c95c340a"
uuid = "a5390f91-8eb1-5f08-bee0-b1d1ffed6cea"
version = "0.10.1"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.7.0+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─a2f22b9d-13f8-4e39-b7dd-14b905d987ab
# ╟─731c88b4-7daf-480d-b163-7003a5fbd41f
# ╟─a5de5746-3df0-45b4-a62c-3daf36f015a5
# ╟─69dca09e-b572-436f-90c6-187af17cf027
# ╟─7edf94e7-6096-4cc8-9c3a-d85f40aab75b
# ╟─6498b10d-bece-42bf-a32b-631224857753
# ╟─95db374b-b10d-4877-a38d-1d0ac45877c4
# ╟─f655b1ba-d80e-42b1-8552-30d65414aeb0
# ╟─6ab6d757-1bcf-4ccd-b7d2-33eba8e7ce81
# ╟─10a73b76-b6ad-4081-b8b1-21363608618e
# ╟─42f7e15d-9abc-40ca-bd70-7131957907a5
# ╟─c8207eb0-2359-4d62-8f9f-4ff3960b23ee
# ╟─71273ef0-b33a-4e77-9510-483fe304b74d
# ╟─b33e1473-e374-441b-a6a4-6c2a7b079c98
# ╟─7bb29c12-c0a0-4eb0-a4d6-bd9c52443751
# ╟─f89f6fc4-cb6f-4d7b-84c9-f8a18e764427
# ╟─a93b1f32-a12f-42db-be52-8f0365d6cb76
# ╟─313959e0-eea6-449a-a6b8-29c9394e50b6
# ╟─e20b95fa-e038-4d3b-82ca-8a38262c64c4
# ╟─99b2ef18-11bd-40ed-92f6-143b504a036d
# ╟─54fc1118-d78b-40f2-bfa9-86a6034006e0
# ╟─2bf62523-a0f1-400e-9178-79062e0a171e
# ╟─206df1a6-bf12-4957-93f7-472ee89594c4
# ╟─c8f703dc-5a1c-4c39-b9a4-c3dd0a2806d8
# ╟─46aa48e7-eb56-4fa5-aeac-36119b1140a2
# ╟─13a58974-2ae8-4596-933f-5d2b5b8f5a23
# ╟─e89beeee-1ad9-4440-ba95-9bd0eb6bfe72
# ╟─84009ee2-cfc3-437c-8782-d370b8b8c4f6
# ╟─ecf1df36-eb3e-4074-9a36-774a3b6b0f72
# ╟─a2df8dc1-f6da-4816-85b9-c7caadc03584
# ╟─aa7c586a-dc74-401f-ae85-8ab3a915680a
# ╟─de202dfb-ddcf-432e-ae47-9639acb35065
# ╟─5db80dee-c643-4cc1-bca4-00b1ffd0a948
# ╟─0357258e-8133-4ef3-946f-5134a9560b9d
# ╟─4c7a13f2-05a9-4069-89ba-4e91a0bdf7db
# ╟─284c7ed7-7417-4bda-8a30-04eebd657bd5
# ╟─ae67f236-60ec-4c2e-abd3-9ea537200ca3
# ╟─fa1dcebd-4a54-433b-897c-de2929fb8233
# ╟─00ce1a7e-a0db-4ebb-a2d5-d31e19696d3c
# ╟─0a44df3e-a05c-4d6f-9c7e-66695d7f68e3
# ╟─2452e56b-2a61-4608-9ca0-55c8cdca89c6
# ╟─f688e93c-e8b1-4718-b56e-d76bf70eef57
# ╟─a9e13bf5-cf0a-46eb-b651-764bf000cad4
# ╟─4914c857-5dc8-43b8-8e70-377debbc3d0c
# ╟─ef2c8029-5bc9-4229-b321-0d9da728ead1
# ╟─d0d49aab-5f88-4319-b81b-4e8fc036d1b3
# ╟─d25744ad-fbe3-4f08-b17a-d00d51bcb2b8
# ╟─f61d7698-b925-467a-9d7a-2430c1d93026
# ╟─78231e48-0137-4e25-a149-5c87c92e7b9c
# ╟─382a9c58-4baa-4ad2-9f32-7189d4881c50
# ╟─deb54591-8769-480d-98ad-32157abac2c0
# ╟─3578793a-e0b6-42de-941b-2db09ef99e49
# ╟─82db2847-a1a1-45a3-8d29-c3ac4213591c
# ╟─5872c555-5d6d-4f74-ab85-d0a85d2be11d
# ╟─adbc8a60-c33c-44ba-a284-fa7b676b9618
# ╠═1a6add34-52e1-4663-9228-f0fca63f8cc2
# ╟─8de081f6-2b7f-4d03-b565-b4ac01c2773e
# ╟─906ed779-494d-442b-b787-a187f69aca9f
# ╟─64de511a-bba4-4df2-a9a3-2992d5333bc3
# ╟─d296b99d-588d-48ac-8e0c-a0bcbde72c56
# ╟─0b29d855-ac09-4342-a7d1-110add543f3c
# ╟─27593a90-7d18-4afd-8b0c-701021f23194
# ╟─1c4db2fa-7187-4966-aa3f-9a7f56036497
# ╟─3a3b7641-ed63-4cce-a98c-a4cf1b6e603d
# ╟─2384b88b-e8dc-4e9c-9488-27828da0289d
# ╟─a13a140d-51b4-43a1-b5e6-7cb5026f9ed8
# ╟─c5311825-1d43-406c-ac88-094cbc198746
# ╟─0918383a-9a0b-4f8c-ba63-aaad1cf6d72c
# ╟─c9b876e2-cb29-4a70-9c1f-abb2dedf3fe2
# ╟─d912c3cb-c1a6-46fe-af9d-25a75074b31d
# ╟─f3949f40-c3c9-4031-aae9-5954fd3e7e27
# ╟─2a701d2c-e526-40a7-93ee-544e5f5b7a7c
# ╟─40df1177-48cf-4cb2-9860-11d2d9f0a450
# ╟─be69c9e5-c610-4317-96f8-4bc1fbd8dd75
# ╟─43e1d6ae-bccb-4974-b2d0-a1876228d263
# ╟─76774fcb-f806-4db2-b653-fe69720f43a7
# ╟─a440a28f-04af-4248-8f2b-c8e6a726c07a
# ╟─e79d1c10-787b-442a-a80b-934c8bb80dd1
# ╟─84d6304e-3bb3-431b-9afd-814bea33dd71
# ╟─fef5577e-025f-4afc-9fd9-aa025146858e
# ╟─5760f508-8d91-47ec-9177-fbce8e08462b
# ╟─bc22c5ed-b8d6-4bf8-a325-78dea3388c11
# ╟─90883b07-064f-4395-a805-ddaaad7f97fd
# ╟─faecc806-5f33-49c6-a463-b349cbfb8acc
# ╟─c7a254a6-d877-4de0-a3e5-a64fb93ae079
# ╟─3cbe2b93-d0a2-429e-8389-9eea20abaa79
# ╟─2e818466-ca18-46b4-9072-933debe49523
# ╟─9b53686c-e362-46c5-bdd9-0c388d9cd122
# ╟─9d0017a5-6b7b-4c1b-9323-7a8fdc54db77
# ╟─69d8c85f-3735-4bd2-bd37-1ddadab87140
# ╟─bc9967a4-ad61-41b5-88ab-5a676beb5637
# ╟─1e4bda9a-9265-4692-b056-13637878343f
# ╟─cf1fa1d8-da24-4f48-8762-affa1f58279a
# ╟─c9e610fb-2bda-4538-8979-267a97d9619c
# ╟─0abc165c-17de-4c15-97e1-f9e3506bcd1b
# ╟─3000e0f6-381f-4a9c-85c1-c517af617f14
# ╟─085b1908-4421-4f3b-8876-3fe0fd6f805a
# ╟─214ef16f-329e-4549-99b9-d6a39724f50a
# ╟─5c8f4910-7b54-414a-8eb9-52104c0ff36e
# ╟─972e44da-4614-4349-bcb7-edb0518fe24d
# ╟─a1c74635-2fb9-492c-8243-4232b771718b
# ╟─45ffcfef-16f3-464a-b868-0d3f64cb6019
# ╟─c1e9807b-5428-4ac1-be09-63847c3b5b5e
# ╟─874afd1d-eba3-4295-9f96-7502c187b171
# ╟─95110a89-1d2b-4c83-9b1c-d7dc95ab89c8
# ╟─aa70d2f6-c726-45cc-89cb-bb6afb85f065
# ╟─cf6ef91d-7ebe-4b64-b7af-61fe6b5b1ff2
# ╟─37af6f97-f9c5-4488-bba5-cd1a993a6a08
# ╟─d69cce2c-dce4-4369-b3db-968c0b4d3dc6
# ╟─ccba5159-b6bb-4c98-8f04-8dd91c032146
# ╟─f50d144b-6d62-4b3f-b85a-d76861ea2ae0
# ╟─0f8f4ec6-c3a9-4ca0-a2e6-750714e0ab14
# ╟─30e93a80-d035-49f4-852c-040c68a862da
# ╟─c4aa9ab9-5502-4676-8b6a-5b55cc645e03
# ╟─f481451a-6949-4604-811b-6b4c530fd644
# ╟─00683f9c-6f56-4457-a6eb-a680d7435ed5
# ╟─0a51ba4b-2596-433e-ab47-7f3d0d1ad916
# ╟─992074c6-d6d5-4417-9edc-0229a0333070
# ╟─093d0720-9acd-4fcf-9822-ed6ced3bdda2
# ╟─b9da0c02-3246-48b2-8922-91c4e46638f4
# ╟─cc282e0d-9faa-4808-b506-335e9097f2fe
# ╟─d44298e3-5763-4249-8140-5eefb80adb49
# ╟─57759a33-f026-4c15-91ba-f6af45627f1e
# ╟─9c596473-76f6-4e9a-b3dd-32add39eaf92
# ╟─e17a53b2-23c4-4ae6-aa55-e410fbd88b5a
# ╟─9db71771-d778-4d43-af7a-80d8cfff97ff
# ╟─36678746-8926-451d-b692-b57c620170c5
# ╟─702d7ff3-e641-4a2b-a8ec-0f1cc0f2ba71
# ╟─8f65e51f-01d6-4d02-bee2-f7d16f62a6c2
# ╟─e16d631b-befe-4657-ad03-e65b5999e49a
# ╟─cb095719-ba0a-49e4-8cb4-fbf28e63c012
# ╟─96b74c6d-5d6e-4c91-8bd2-6eec2fedf308
# ╟─53c77ef1-899d-47c8-8a30-ea38380d1614
# ╟─670e45a3-9d28-47ae-a6b6-a1b1c67a0a4c
# ╟─e4f05023-5e88-4d5d-a74a-83f25a84b6b2
# ╟─2ee2c328-5ebe-488e-94a9-2fce2200484c
# ╟─25448e4a-345b-4bd6-9cdb-a6a280cfd22c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
