### A Pluto.jl notebook ###
# v0.19.8

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 1f0cb625-d1ec-4775-bc75-59d4675d181e
# ╠═╡ show_logs = false
begin
	using Logging
	global_logger(NullLogger())
	display("")
end

# ╔═╡ 25448e4a-345b-4bd6-9cdb-a6a280cfd22c
# ╠═╡ show_logs = false
#Set-up packages
begin
	
	using PlutoUI, DataFrames, HTTP, CSV, Dates, Printf, LaTeXStrings, HypertextLiteral, XLSX
	
	# gr();
	# Plots.GRBackend()


	#Define html elements
	nbsp = html"&nbsp" #non-breaking space
	vspace = html"""<div style="margin-bottom:0.05cm;"></div>"""
	br = html"<br>"

	#Sets the width of cells, caps the cell width by 90% of screen width
	#(setting overwritten by cell below)
	# @bind screenWidth @htl("""
	# 	<div>
	# 	<script>
	# 		var div = currentScript.parentElement
	# 		div.value = screen.width
	# 	</script>
	# 	</div>
	# """)

	
	# cellWidth= min(1000, screenWidth*0.9)
	# @htl("""
	# 	<style>
	# 		pluto-notebook {
	# 			margin: auto;
	# 			width: $(cellWidth)px;
	# 		}
	# 	</style>
	# """)
	

	#Sets the width of the cells
	#begin
	#	html"""<style>
	#	main {
	#		max-width: 900px;
	#	}
	#	"""
	#end


	#Sets the height of displayed tables
	html"""<style>
		pluto-output.scroll_y {
			max-height: 550px; /* changed this from 400 to 550 */
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

	display("")
end

# ╔═╡ a2f22b9d-13f8-4e39-b7dd-14b905d987ab
#add button to trigger presentation mode
html"<button onclick='present()'>present</button>"

# ╔═╡ 731c88b4-7daf-480d-b163-7003a5fbd41f
begin 
	html"""
	<p align=left style="font-size:25px; font-family:family:Georgia"> <b> UD/ISCTE-IUL Trading and Bloomberg Program</b> <p>
	"""
end


# ╔═╡ a5de5746-3df0-45b4-a62c-3daf36f015a5
begin 
	html"""
	<p style="padding-bottom:1cm"> </p>
	<div align=center style="font-size:25px; font-family:family:Georgia">Fixed Income Securities </div>
	<p style="padding-bottom:1cm"> </p>
	<p align=center style="font-size:25px; font-family:family:Georgia"> <b> U.S. Treasury Securities Market</b> <p>
	<p style="padding-bottom:1cm"> </p>
	<p align=center style="font-size:25px; font-family:family:Georgia"> Summer 2022 <p>
	<p style="padding-bottom:1cm"> </p>
	<div align=center style="font-size:20px; font-family:family:Georgia"> Prof. Matt Fleckenstein </div>
	<p style="padding-bottom:0.0cm"> </p>
	<div align=center style="font-size:20px; font-family:family:Georgia"> University of Delaware, 
	Lerner College of Business and Economics </div>
	<p style="padding-bottom:0.5cm"> </p>
	"""
end

# ╔═╡ 69dca09e-b572-436f-90c6-187af17cf027
TableOfContents(aside=true, depth=1)

# ╔═╡ 6498b10d-bece-42bf-a32b-631224857753
md"""
# Overview
"""

# ╔═╡ 95db374b-b10d-4877-a38d-1d0ac45877c4
begin
	html"""
	<fieldset>      
        <legend>Our goals for today</legend>      
		<br>
        <input type="checkbox" value="">Introduction to the U.S. Treasury Securities 		Market<br>      
		<br>
        <input type="checkbox" value="">Treasury Bills<br>      
		<br>
        <input type="checkbox" value="">Treasury Notes and Bonds<br>      
		<br>
        <input type="checkbox" value="">Treasury STRIPS<br>           
		<br>
		<input type="checkbox" value="">Treasury TIPS<br> 
        <br>
	    <input type="checkbox" value="">Inflation Swaps<br>      
		<br>
	  	</fieldset>      
	"""
end

# ╔═╡ 61346ddf-bea9-442d-9086-040b78073884
md"""
##
"""

# ╔═╡ 10a73b76-b6ad-4081-b8b1-21363608618e
md"""
# The U.S. Treasury Market
- The Department of the Treasury is the largest single issuer of debt in the world.
- The large volume of total debt and the large size of any single issue have contributed to making the Treasury market the most active and hence the most liquid market in the world


[SIFMA Fixed Income Statistics](https://www.sifma.org/resources/research/fixed-income-chart)
"""

# ╔═╡ 1bf762d9-5652-4a2b-9eda-ad1231c1c83b
md"""
##
"""

# ╔═╡ b33e1473-e374-441b-a6a4-6c2a7b079c98
md"""
## U.S. Treasury Debt Amount Outstanding
"""

# ╔═╡ f89f6fc4-cb6f-4d7b-84c9-f8a18e764427
md"""
##
"""

# ╔═╡ 313959e0-eea6-449a-a6b8-29c9394e50b6
LocalResource("./Assets/TreasuryOutstandingSIFMA.svg",:width => 900)

# ╔═╡ e20b95fa-e038-4d3b-82ca-8a38262c64c4
md"""
[Link to SIFMA](https://www.sifma.org/resources/research/fixed-income-chart/)
"""

# ╔═╡ 95318eb1-357f-4880-a83d-732d8dc5f7de
md"""
##
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

# ╔═╡ 2452e56b-2a61-4608-9ca0-55c8cdca89c6
LocalResource("./Assets/TreasuryDirect_01.png",:width => 900)

# ╔═╡ f688e93c-e8b1-4718-b56e-d76bf70eef57
md"""
##
"""

# ╔═╡ 4914c857-5dc8-43b8-8e70-377debbc3d0c
LocalResource("./Assets/TreasuryDirect_02.png",:width => 900)

# ╔═╡ 49aeda6d-b718-46d0-92ca-79f59a81ae14
md"""
##
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

# ╔═╡ 382a9c58-4baa-4ad2-9f32-7189d4881c50
md"""
## Example of 52-week Treasury Bill
"""

# ╔═╡ deb54591-8769-480d-98ad-32157abac2c0
LocalResource("./Assets/BloombergTBill_01.png", :width=>900)

# ╔═╡ 3578793a-e0b6-42de-941b-2db09ef99e49
md"""
>- How to get there on the Bloomberg terminal?
>  - Open a terminal and on the keyboard type `T Bill`.
>  - In the popup window,  select `B Govt - United States Treasury Bill (Multiple Matches)`.
>  - Next, click on one of the different Treasury bills in the list.
>  - Then, click on `DES` on the top-right, or type `DES` on the keyboard and press enter.
"""

# ╔═╡ 82db2847-a1a1-45a3-8d29-c3ac4213591c
md"""
##
"""

# ╔═╡ d296b99d-588d-48ac-8e0c-a0bcbde72c56
md"""
# Treasury Note (T-Note)
- Medium-term securities with maturities of 2, 3, 5, 7, and 10 years.
- Treasury notes pay interest every six months up to and including the maturity date.
  - Example: A 2-year T-note has its last interest payment in two years, and it pays interest after 6 months, 12 months, and 18 months.
- At maturity, Treasury notes pay back their par value.
"""

# ╔═╡ 1c4db2fa-7187-4966-aa3f-9a7f56036497
md"""
## Example of 10-year Treasury Note
"""

# ╔═╡ 3a3b7641-ed63-4cce-a98c-a4cf1b6e603d
LocalResource("./Assets/BloombergTNote_01.png")

# ╔═╡ 2384b88b-e8dc-4e9c-9488-27828da0289d
md"""
>- How to get there on the Bloomberg terminal?
>  - Open a terminal and on the keyboard type `T Note`.
>  - In the popup window,  select `T Govt - United States Treasury Note/Bond (Multiple Matches)`.
>  - Next, click on one of the different Treasury notes in the list.
>  - Then, click on `DES` on the top-right, or type `DES` on the keyboard and press enter.
"""

# ╔═╡ 0918383a-9a0b-4f8c-ba63-aaad1cf6d72c
md"""
- Let's look at price quotes for this Treasury note.
- If you were to purchase this Treasury note, would you pay \$95.02?
- The answer is _no_. Prices for Treasury notes are quoted in a specific way, which we will discuss in the next lecture.
"""

# ╔═╡ c9b876e2-cb29-4a70-9c1f-abb2dedf3fe2
LocalResource("./Assets/BloombergTNote_02.png")

# ╔═╡ d912c3cb-c1a6-46fe-af9d-25a75074b31d
md"""
>- How to get there on the Bloomberg terminal?
>  - From the `Description` page where you are currently at, type `GP` and press enter.
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

# ╔═╡ 4567e3a2-24fb-494f-8005-801b03ffeabf
#https://www.treasurydirect.gov/indiv/research/history/histtime/histtime_bonds.htm

# ╔═╡ 76774fcb-f806-4db2-b653-fe69720f43a7
md"""
## Coupon bonds
- Treasury notes and bonds are referred to as **coupon** securities.
- Why?
"""

# ╔═╡ a440a28f-04af-4248-8f2b-c8e6a726c07a
LocalResource("./Assets/TreasuryCouponPicture.svg",:width => 900)

# ╔═╡ 344b41a7-7257-4dc0-babd-456ca3cdc4c6
md"""
# Example of Treasury Note Cash Flows
"""

# ╔═╡ fee10643-3176-45b3-b424-3f479874561e
LocalResource("./Assets/TreasuryNoteCashflowExample.png",:width => 900)

# ╔═╡ c32458ce-5884-4385-8b65-dc322445aaf6
# md"""
# - Par Value $F$ = \$100.
# - Coupon Rate $c$ [% p.a.]:  $(@bind CTnote Slider(0:0.1:10.0, default=10, show_value=true))
# - Time to maturity $T$ [years]:  $(@bind TTnote Slider(1.0:1:10.0, default=5.0,show_value=true))
# """

# ╔═╡ 47558761-7341-40e0-bdda-7d30f5527f4b
# let
# 	CF = 0.5*CTnote.*ones(convert(Int64,TTnote*2))
# 	CF[end] += 100
# 	dt = collect(0.5:0.5:TTnote)
# 	bar(dt,CF,label="", ylim=(0,120), xlim=(0,TTnote+1), xticks=collect(0.0:0.5:TTnote), xlabel="Years", ylabel="Coupon Cash Flow")
# end

# ╔═╡ fef5577e-025f-4afc-9fd9-aa025146858e
md"""
# Treasury Floating Rate Note (FRN)
- First issued in 2014 by the U.S. Treasury.
- Maturity of 2 years.
- Pay interest every three months up to and including the maturity date.
  - At maturity, FRNs pay back their par value.
- The interest on an FRN varies with interest rate on 13-week Treasury bills.
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

# ╔═╡ cc282e0d-9faa-4808-b506-335e9097f2fe
md"""
## Treasury STRIPS in Bloomberg
"""

# ╔═╡ d44298e3-5763-4249-8140-5eefb80adb49
LocalResource("./Assets/TreasurySTRIPSBloomberg.png",:width => 900)

# ╔═╡ 57759a33-f026-4c15-91ba-f6af45627f1e
md"""
>- How to get there on the Bloomberg terminal?
>  - Open a terminal and on the keyboard type `Treasury STRIP`.
>  - In the popup window,  select `S Govt - United States Treasury Strip Coupon (Multiple Matches)`.
>  - Next, click on one of the different Treasury bills in the list.
>  - Then, click on `DES` on the top-right, or type `DES` on the keyboard and press enter.
"""

# ╔═╡ 9c596473-76f6-4e9a-b3dd-32add39eaf92
md"""
##
"""

# ╔═╡ 9db71771-d778-4d43-af7a-80d8cfff97ff
LocalResource("./Assets/BloombergSTRIPS_01.png")

# ╔═╡ 9aa2c9f6-5a3e-4138-8352-e8d293f340a8
md"""
##
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

# ╔═╡ 3000e0f6-381f-4a9c-85c1-c517af617f14
md"""
- Why inflation matters ...
  - [WSJ, June 10, 2022: U.S. Inflation Hit 8.6% in May. Energy, groceries, shelter costs drive fastest rise in consumer-price index since December 1981](https://www.wsj.com/articles/us-inflation-consumer-price-index-may-2022-11654810079)
  - [WSJ, January 12, 2022: U.S. Inflation Hit 7% in December, Fastest Pace Since 1982](https://www.wsj.com/articles/us-inflation-consumer-price-index-december-2021-11641940760?mod=article_inline)
  - [WSJ, February 10, 2022: U.S. Inflation Rate Accelerates to a 40-Year High of 7.5%](https://www.wsj.com/articles/us-inflation-consumer-price-index-january-2022-11644452274?mod=hp_lead_pos1)
  - [WSJ, February 6, 2022: What Investors Should Know About TIPS](https://www.wsj.com/articles/tips-what-investors-should-know-treasury-inflation-protected-securities-11643849892?mod=hp_lista_pos1)"""

# ╔═╡ 80a54df2-24e1-4c9e-a292-8b3c57e797dd
md"""
##
"""

# ╔═╡ 889c4a84-b6c3-4495-8ef9-cd2d862259a6
LocalResource("./Assets/TreasuryAmountOutstanding.png")

# ╔═╡ 8ebcfea4-53a2-47dc-b4fa-868bb2a570b4
# #US Treasury Market
# begin
# 	TreasMkt = DataFrame()
# 	plot_Treas = plot()
# 	let
# 		data_url = "https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/US-Treasury-Securities-Statistics-SIFMA_Outstanding.csv"
# 		my_file = CSV.File(HTTP.get(data_url).body; missingstring="-999")
# 		# my_file = CSV.File("./Assets/US-Treasury-Securities-Statistics-SIFMA_Outstanding.csv")
#  		TreasMkt = DataFrame(my_file)
		
# 		transform!(TreasMkt, [:Notes,:Bonds] => (+) => :NotesAndBonds)
# 		transform!(TreasMkt, 
# 		  [:TIPS, :Total] => ByRow( (x,y)->any(ismissing.([x,y])) ? 
# 		 		missing :  (x/y*100)) => :TIPSPctTreas)
		
# 		minX = 1997
# 		maxX = 2020
# 		minY = 0.0
# 		maxY = 2000.0
# 		plot!(plot_Treas, TreasMkt.Year,TreasMkt.TIPS, 
# 		  	xlim=(minX,maxX), ylim=(minY, maxY), 
# 		  	ylabel="Billions of Dollars",label="TIPS",
# 		  	legend = :topleft, title="Amount Outstanding",right_margin = 15Plots.mm)	
# 		subplot=twinx()
# 		plot!(subplot, TreasMkt.Year,TreasMkt.TIPSPctTreas, color=:red,
# 			xlim=(minX,maxX), ylim=(0,20), ylabel = "Percent", 
# 			yticks=(0:5:20),label = "TIPS to Treasury Debt")	
# 		plot(plot_Treas)
# 	end
# end

# ╔═╡ 5c8f4910-7b54-414a-8eb9-52104c0ff36e
md"""
## Example of a Treasury TIPS
"""

# ╔═╡ 972e44da-4614-4349-bcb7-edb0518fe24d
LocalResource("./Assets/BloombergTIPS_01.png")

# ╔═╡ a1c74635-2fb9-492c-8243-4232b771718b
md"""
>- How to get there on the Bloomberg terminal?
>  - Open a terminal and on the keyboard type `Treasury TIPS`.
>  - In the popup window,  select `TII Govt - United States Treasury Inflation Indexed Bonds (Multiple Matches)`.
>  - Next, click on one of the different Treasury bills in the list.
>  - Then, click on `DES` on the top-right, or type `DES` on the keyboard and press enter.
"""

# ╔═╡ 45ffcfef-16f3-464a-b868-0d3f64cb6019
md"""
##
"""

# ╔═╡ 874afd1d-eba3-4295-9f96-7502c187b171
md"""
- Let's look at price quotes for this Treasury TIPS.
- If you were to purchase this Treasury TIPS, would you pay \$105.28?
- The answer is _no_. Prices for Treasury TIPS are quoted in a specific way, which we will discuss in the next lecture.
"""

# ╔═╡ 95110a89-1d2b-4c83-9b1c-d7dc95ab89c8
LocalResource("./Assets/BloombergTIPS_02.png")

# ╔═╡ aa70d2f6-c726-45cc-89cb-bb6afb85f065
md"""
>- How to get there on the Bloomberg terminal?
>  - From the `Description` page where you are currently at, type `GP` and press enter.
"""

# ╔═╡ 7930b421-9b9d-4029-aad1-affd0b36b432
md"""
##
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
LocalResource("./Assets/SoldiersDepreciationNote.svg",:width => 900)

# ╔═╡ 8dff2987-d375-441c-b6fe-5fceb32f9117
md"""
# Indexing Bonds to Inflation
"""

# ╔═╡ ce096e20-bed9-4de1-8af5-b9eefe898ebd
md"""
- Treasury Inflation-Protected Securities (TIPS) are _index-linked_ bonds.
  - An index-linked bond is one whose _cash flows_ are linked to movements in a specific price index.
- The _principal amount_ of a TIPS is indexed to the price level. 
  - Since a fixed coupon rate is applied to the principal that varies with the price level, the actual coupon cash flows vary in response to the realized rate of inflation.
- Index-linked bonds are usually indexed to a broad measure of prices, typically a domestic _Consumer Price Index (CPI)_.
"""

# ╔═╡ 89b1d772-517c-48b5-8928-db6e053576f1
md"""
# U.S. Consumer Price Index
- In the U.S. this price index is the Consumer Price Index for All Urban Consumers (_CPI-U_).
- The CPI-U measures the level of prices paid by consumers for goods and services. 
- This index is published by the Bureau of Labor Statistics (BLS) every month.
- [Bureau of Labor Statistics](https://www.bls.gov/schedule/news_release/cpi.htm); [Bureau of Labor Statistics Release](https://www.bls.gov/news.release/pdf/cpi.pdf)
"""

# ╔═╡ 813ffddc-3273-4fd0-9469-e78b9175335b
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/USCPIYoY.svg",:width => 900)


# ╔═╡ 5f87817d-a6d0-4506-b8a2-5327ef0734bd
md"""
Source: [BLS.gov](https://www.bls.gov/charts/consumer-price-index/consumer-price-index-by-category-line-chart.htm)
"""

# ╔═╡ b51b9209-76f7-43b9-b539-a7ff17f9148d
md"""
##
"""

# ╔═╡ c4aa9ab9-5502-4676-8b6a-5b55cc645e03
md"""
## TIPS Inflation-Adjustment
"""

# ╔═╡ f481451a-6949-4604-811b-6b4c530fd644
LocalResource("./Assets/TIPSInflationAdjustment.svg",:width => 900)

# ╔═╡ 36678746-8926-451d-b692-b57c620170c5
md"""
##
"""

# ╔═╡ 4e0d6bde-f652-4260-a2bf-03da8c2012c3
md"""
# TIPS Inflation Adjustment Details

- The principal amount of a TIPS (assume $100 at issuance) is adjusted daily based on the CPI-U. 
- The inflation adjustment $I_t$ is computed as the ratio of the **Reference CPI** at the time $t$ divided by the reference CPI when the TIPS was first issued ($t=0$). 
$$I_t = \frac{\textrm{Reference CPI at time } t}{\textrm{Reference CPI at TIPS issue date}}$$

"""

# ╔═╡ 95162814-820b-402e-b8e2-c2a7e511ef8b
md"""
- The **Reference CPI** for a particular date $t$ during a month is linearly interpolated from the **Reference CPI** for the beginning of that month and the **Reference CPI** for the beginning of the subsequent month.
  - The **Reference CPI** for the first day of _any_ calendar month is the CPI-U index for the third preceding calendar month. 
"""

# ╔═╡ 86ed68e9-e097-4385-abdf-172763ee6281
md"""
- _Example 1_: the **Reference CPI** for _April 1_ is the CPI-U index for the month of _January_ (which is reported by the BLS during February).
- _Example 2_: the **Reference CPI** for _April 15_ is roughly the average of the CPI-U index for the month of _January_ and the CPI-U index for the month of February.
"""

# ╔═╡ 358b0a71-e722-4622-90e5-a875acaf5e21
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/ReferenceCPI_Des.png",:width => 900)


# ╔═╡ def2b50e-a660-4d98-9efe-67413ef76d37
md"""
##
"""

# ╔═╡ dd30bcd0-939d-4907-b4e9-6a559a71426d
md"""
# Deflation Protection
- TIPS have an embedded option that protects against deflation.
- The Treasury guarantees that the _final redemption value is no less than \$100 per \$100 nominal_ amount, irrespective of the movements in the CPI over the life of the bond.
- Let $F$ be the TIPS principal amount and $T$ the time to maturity of the TIPS.
- The principal cash flow at maturity $T$ is
$$F \times \max\left[\, I_T, 1 \,\right]$$
- This deflation protection does not apply to coupon cash flows.
"""

# ╔═╡ 82ba10db-c126-4355-9311-26c1d0ad707c
md"""
##
"""

# ╔═╡ 22c5f11f-d1b0-4780-ae3d-eb0a5c7d5f14
md"""
# Inflation-Adjusted Coupon Interest
"""

# ╔═╡ 51ea0a30-8558-455b-81e3-79fbc8fe59e9
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/of698cpi_crop.svg",:width => 500)


# ╔═╡ 8921aae4-2d39-4ddd-bf19-6b395253e488
md"""
- The Reference CPI is then turned into a ratio to caclulate the inflation adjustment by taking the Reference CPI on the date and dividing by the Reference CPI at issue. 
  - For example, the Reference CPI for January 15, the official issue date of the inaugural TIPS bond is 158.43548. Assume \$100 par value at issuance.
  - Suppose we are on July 15 and the first coupon cash flow is about to be paid. Suppose that the reference CPI on July 15 turns out to be 168.53226.
  - Then, the inflation adjustment factor is 168.53226/158.43458 = 1.063734
  - This means coupon rate is paid on par value of \$100 $\times$ 1.063734 = \$106.3734.
"""

# ╔═╡ 4ce2544f-c66d-4d56-a39d-fc7d5ee6d633
md"""
##
"""

# ╔═╡ f69d0a46-263e-4526-a8b2-ef4f4ee5b762
md"""
# Inflation-Adjusted Coupon Interest Example
"""

# ╔═╡ 68942dbc-0cdc-4201-a10e-bfbb2b56c73f
md"""
- Let $F$ be the TIPS principal value.
- Let $c$ denote the (fixed) _real_ coupon rate on the TIPS.
- Let $T$ denote the time to maturity of the TIPS (in years).

"""

# ╔═╡ 8ffac44e-56cd-435e-be5c-d72e8be35941
md"""
- Principal $F$ [$]: $(@bind F Slider(100:100:1000, default=100, show_value=true))
- Real Coupon Rate c [%]: $(@bind c Slider(0:0.25:10, default=3, show_value=true))
- Time to Maturity $T$ [years]: $(@bind T Slider(1:1:30, default=5, show_value=true))
- Reference CPI at issue date: $(@bind I₀ Slider(100:1:300, default=100, show_value=true))
"""

# ╔═╡ d6e02f5e-cb9e-440c-a335-a487db0d0930
Markdown.parse("
- Suppose, \$c= $c \\%\$ and \$F=$F\$.
- In real terms, the coupon cash flows at each coupon date are 
		
\$\\frac{c}{2} \\, F = \\frac{$(c/100)}{2} \\, $F = $(c/200*F)\$
	
- Suppose there is inflation (or deflation).
- The actual cash flows (in nominal terms) of the TIPS are:
")

# ╔═╡ 5b9336cd-e88d-478f-8711-bde0da5724be
begin
	cfDates = collect(0.5:0.5:T)
	randNormal = randn(length(cfDates))
	refCPI = zeros(length(cfDates))
	refCPI[1] = I₀ + (1+randNormal[1])
	for ii=2:length(refCPI)
    	refCPI[ii] = refCPI[ii-1] + (0+randNormal[ii]);
	end
	Infl = (refCPI./I₀ .-1)*100
	IIₜ = refCPI./I₀
	adjPrin = F.*IIₜ
	adjPrin[end] = maximum([100,F.*IIₜ[end]])
	cfAmounts = (c/200)*F.*IIₜ.*vec(ones(length(cfDates),1))
	cfAmounts[end] = cfAmounts[end]+100*maximum([IIₜ[end],1])
	df = DataFrame(Time=cfDates, Reference_CPI=refCPI, Iₜ=IIₜ, Adjusted_Principal=adjPrin, Cashflows=cfAmounts,)
end

# ╔═╡ b401991e-ef32-4cee-8630-d9f54635aec3
md"""
##
"""

# ╔═╡ 0dee4432-9118-428a-9b49-ca2648e14fcd
md"""
# Inflation Derivatives

- In addition to the cash inflation market, there is an active derivatives market that consists mainly of inflation swap contracts and inflation options. 
"""

# ╔═╡ 6e529940-7f36-4bdd-8adb-1f34b2825d32
md"""
# Inflation Swap Basics
"""

# ╔═╡ be39cbe4-9b57-4827-b649-45655cb49270
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/InflSwap_Chart.svg",:width => 400)


# ╔═╡ 27a48326-0265-4334-b7cd-0c2fe3595999
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/InflSwap1Yr_Des.png",:width => 900)


# ╔═╡ 9ffda585-493f-4ffe-b360-dcf1420f107c
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/InflSwap1Yr_PxQuotes.png",:width => 900)


# ╔═╡ 2533a3d3-d368-4036-bea4-79645fe9adf2
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/InflSwap1Yr_Graph.png",:width => 900)


# ╔═╡ 19eceb43-c982-4e99-a9d4-de229ac948e7
md"""
##
"""

# ╔═╡ 636cdd0c-88c9-4c5a-833a-db2a49014c75
md"""
# Inflation Swap Cash Flows
"""

# ╔═╡ 29718094-db53-434b-ae91-5d93d06d857b
md"""
- The swap is executed between two counterparties at time $t=0$ and has only one cash flow that occurs at maturity in $T$ years.
"""

# ╔═╡ e4458558-d2be-4d88-82cc-db1335c49aa8
md"""
- For example, imagine that at time $t=0$, the five-year zero-coupon inflation swap rate is 200 basis points and that the inflation swap has a notional of \$1. 
- There are no cash flows at time $t=0$ when the swap is executed. 
- At the maturity of the swap in $T=5$ years, suppose that realized inflation is $I_T$, then the counterparties to the inflation swap exchange a cash flow of 

$$\left[ (1 + 0.0200)^5 -1 \right] − \left[I_T -1 \right],$$
"""

# ╔═╡ 89646676-3a58-437b-ba49-df1732b43ba7
md"""
- Thus, if the realized inflation rate was 1.50% per year over the five-year horizon of the swap, 

$$I_T = 1.015^5 = 1.077284$$ 

- In this case, the net cash flow per \$1 notional of the swap from the swap would be 


$$\left[ (1 + 0.0200)^5 -1\right] − \left[1.077284 -1 \right]= 0.026797$$ 
"""

# ╔═╡ 19706e83-7306-4383-ac7f-55346d977d6e
md"""
##
"""

# ╔═╡ 688eae45-6d4f-467a-a00b-911355528f66
md"""
# Inflation Swap Example
"""

# ╔═╡ 38b29bc7-bd8c-4fe8-bc1a-17e3dc6c79f5
md"""
- Notional $N$ [$]: $(@bind Nswap Slider(100:100:1000, default=100, show_value=true))
- Inflation Swap Rate $f$ [%]: $(@bind fswap Slider(0:0.25:10, default=3, show_value=true))
- Time to Maturity $T$ [years]: $(@bind Tswap Slider(1:1:30, default=5, show_value=true))
- Annual Inflation Rate $I$ [%]: $(@bind Iswap Slider(0:0.25:10, default=2, show_value=true))
"""

# ╔═╡ d320b509-675c-45a8-8b75-bdc449bbc6fe
Markdown.parse("
- Cash flow on the fixed leg of the inflation swap:

\$N \\times \\left[ (1+f)^T - 1 \\right] = $(Nswap) \\times \\left[ (1+ $(fswap/100))^{$(Tswap)} -1 \\right]= $(roundmult(Nswap*( (1+fswap/100)^Tswap -1),1e-4))\$
	
- Cash flow on the floating leg of the swap:
	
\$N \\times \\left[ (1+I)^T - 1 \\right]]= $(Nswap) \\times \\left[ (1+$(Iswap/100))^{$(Tswap)} - 1 \\right]=$(roundmult(Nswap*((1+Iswap/100)^Tswap-1),1e-4))\$
	
- Net cash flow of inflation buyer: $(roundmult(Nswap*(1+Iswap/100)^Tswap - Nswap*(1+fswap/100)^Tswap,1e-4))
")

# ╔═╡ 71606cb8-7ed2-4a70-b229-017cc0d21714
md"""
##
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
        <input type="checkbox" value="" checked>Introduction to the U.S. Treasury Securities 		Market<br>      
		<br>
        <input type="checkbox" value="" checked>Treasury Bills<br>      
		<br>
        <input type="checkbox" value="" checked>Treasury Notes and Bonds<br>      
		<br>
        <input type="checkbox" value="" checked>Treasury STRIPS<br>           
		<br>
		<input type="checkbox" value="" checked>Treasury TIPS<br> 
        <br>
	    <input type="checkbox" value="" checked>Inflation Swaps<br>      
		<br>
	  	</fieldset>      
	"""
end

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
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"
XLSX = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"

[compat]
CSV = "~0.9.11"
DataFrames = "~1.3.1"
HTTP = "~0.9.17"
HypertextLiteral = "~0.9.3"
LaTeXStrings = "~1.3.0"
PlutoUI = "~0.7.39"
XLSX = "~0.7.8"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.3"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings"]
git-tree-sha1 = "49f14b6c56a2da47608fe30aed711b5882264d7a"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.9.11"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "44c37b4636bc54afac5c574d2d02b625349d6582"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.41.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "ae02104e835f219b8930c7664b8012c93475c340"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.2"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.EzXML]]
deps = ["Printf", "XML2_jll"]
git-tree-sha1 = "0fa3b52a04a4e210aeb1626def9c90df3ae65268"
uuid = "8f5d6c58-4d21-5cfd-889c-e3ad7ee6a615"
version = "1.1.0"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "04d13bfa8ef11720c24e4d840c0033d145537df7"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.17"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "61feba885fac3a407465726d0c330b3055df897f"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.1.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "0b5cfbb704034b5b4c1869e36634438a047df065"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "db3a23166af8aebf4db5ef87ac5b00d36eb771e2"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "2cf929d64681236a2e074ffafb8d568733d2e6af"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.3"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "dfb54c4e414caa595a1f2ed759b160f5a3ddcba5"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "15dfe6b103c2a993be24404124b8791a09460983"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.11"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "bb1064c9a84c52e277f1096cf41434b675cd368b"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "c69f9da3ff2f4f02e811c3323c22e5dfcb584cfa"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.1"

[[deps.XLSX]]
deps = ["Dates", "EzXML", "Printf", "Tables", "ZipFile"]
git-tree-sha1 = "96d05d01d6657583a22410e3ba416c75c72d6e1d"
uuid = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"
version = "0.7.8"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[deps.ZipFile]]
deps = ["Libdl", "Printf", "Zlib_jll"]
git-tree-sha1 = "3593e69e469d2111389a9bd06bac1f3d730ac6de"
uuid = "a5390f91-8eb1-5f08-bee0-b1d1ffed6cea"
version = "0.9.4"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─1f0cb625-d1ec-4775-bc75-59d4675d181e
# ╟─25448e4a-345b-4bd6-9cdb-a6a280cfd22c
# ╟─a2f22b9d-13f8-4e39-b7dd-14b905d987ab
# ╟─731c88b4-7daf-480d-b163-7003a5fbd41f
# ╟─a5de5746-3df0-45b4-a62c-3daf36f015a5
# ╟─69dca09e-b572-436f-90c6-187af17cf027
# ╟─6498b10d-bece-42bf-a32b-631224857753
# ╟─95db374b-b10d-4877-a38d-1d0ac45877c4
# ╟─61346ddf-bea9-442d-9086-040b78073884
# ╟─10a73b76-b6ad-4081-b8b1-21363608618e
# ╟─1bf762d9-5652-4a2b-9eda-ad1231c1c83b
# ╟─b33e1473-e374-441b-a6a4-6c2a7b079c98
# ╟─f89f6fc4-cb6f-4d7b-84c9-f8a18e764427
# ╟─313959e0-eea6-449a-a6b8-29c9394e50b6
# ╟─e20b95fa-e038-4d3b-82ca-8a38262c64c4
# ╟─95318eb1-357f-4880-a83d-732d8dc5f7de
# ╟─ae67f236-60ec-4c2e-abd3-9ea537200ca3
# ╟─fa1dcebd-4a54-433b-897c-de2929fb8233
# ╟─2452e56b-2a61-4608-9ca0-55c8cdca89c6
# ╟─f688e93c-e8b1-4718-b56e-d76bf70eef57
# ╟─4914c857-5dc8-43b8-8e70-377debbc3d0c
# ╟─49aeda6d-b718-46d0-92ca-79f59a81ae14
# ╟─d25744ad-fbe3-4f08-b17a-d00d51bcb2b8
# ╟─382a9c58-4baa-4ad2-9f32-7189d4881c50
# ╟─deb54591-8769-480d-98ad-32157abac2c0
# ╟─3578793a-e0b6-42de-941b-2db09ef99e49
# ╟─82db2847-a1a1-45a3-8d29-c3ac4213591c
# ╟─d296b99d-588d-48ac-8e0c-a0bcbde72c56
# ╟─1c4db2fa-7187-4966-aa3f-9a7f56036497
# ╟─3a3b7641-ed63-4cce-a98c-a4cf1b6e603d
# ╟─2384b88b-e8dc-4e9c-9488-27828da0289d
# ╟─0918383a-9a0b-4f8c-ba63-aaad1cf6d72c
# ╟─c9b876e2-cb29-4a70-9c1f-abb2dedf3fe2
# ╟─d912c3cb-c1a6-46fe-af9d-25a75074b31d
# ╟─40df1177-48cf-4cb2-9860-11d2d9f0a450
# ╟─4567e3a2-24fb-494f-8005-801b03ffeabf
# ╟─76774fcb-f806-4db2-b653-fe69720f43a7
# ╟─a440a28f-04af-4248-8f2b-c8e6a726c07a
# ╟─344b41a7-7257-4dc0-babd-456ca3cdc4c6
# ╟─fee10643-3176-45b3-b424-3f479874561e
# ╟─c32458ce-5884-4385-8b65-dc322445aaf6
# ╟─47558761-7341-40e0-bdda-7d30f5527f4b
# ╟─fef5577e-025f-4afc-9fd9-aa025146858e
# ╟─992074c6-d6d5-4417-9edc-0229a0333070
# ╟─cc282e0d-9faa-4808-b506-335e9097f2fe
# ╟─d44298e3-5763-4249-8140-5eefb80adb49
# ╟─57759a33-f026-4c15-91ba-f6af45627f1e
# ╟─9c596473-76f6-4e9a-b3dd-32add39eaf92
# ╟─9db71771-d778-4d43-af7a-80d8cfff97ff
# ╟─9aa2c9f6-5a3e-4138-8352-e8d293f340a8
# ╟─cf1fa1d8-da24-4f48-8762-affa1f58279a
# ╟─3000e0f6-381f-4a9c-85c1-c517af617f14
# ╟─80a54df2-24e1-4c9e-a292-8b3c57e797dd
# ╟─889c4a84-b6c3-4495-8ef9-cd2d862259a6
# ╟─8ebcfea4-53a2-47dc-b4fa-868bb2a570b4
# ╟─5c8f4910-7b54-414a-8eb9-52104c0ff36e
# ╟─972e44da-4614-4349-bcb7-edb0518fe24d
# ╟─a1c74635-2fb9-492c-8243-4232b771718b
# ╟─45ffcfef-16f3-464a-b868-0d3f64cb6019
# ╟─874afd1d-eba3-4295-9f96-7502c187b171
# ╟─95110a89-1d2b-4c83-9b1c-d7dc95ab89c8
# ╟─aa70d2f6-c726-45cc-89cb-bb6afb85f065
# ╟─7930b421-9b9d-4029-aad1-affd0b36b432
# ╟─d69cce2c-dce4-4369-b3db-968c0b4d3dc6
# ╟─ccba5159-b6bb-4c98-8f04-8dd91c032146
# ╟─f50d144b-6d62-4b3f-b85a-d76861ea2ae0
# ╟─8dff2987-d375-441c-b6fe-5fceb32f9117
# ╟─ce096e20-bed9-4de1-8af5-b9eefe898ebd
# ╟─89b1d772-517c-48b5-8928-db6e053576f1
# ╟─813ffddc-3273-4fd0-9469-e78b9175335b
# ╟─5f87817d-a6d0-4506-b8a2-5327ef0734bd
# ╟─b51b9209-76f7-43b9-b539-a7ff17f9148d
# ╟─c4aa9ab9-5502-4676-8b6a-5b55cc645e03
# ╟─f481451a-6949-4604-811b-6b4c530fd644
# ╟─36678746-8926-451d-b692-b57c620170c5
# ╟─4e0d6bde-f652-4260-a2bf-03da8c2012c3
# ╟─95162814-820b-402e-b8e2-c2a7e511ef8b
# ╟─86ed68e9-e097-4385-abdf-172763ee6281
# ╟─358b0a71-e722-4622-90e5-a875acaf5e21
# ╟─def2b50e-a660-4d98-9efe-67413ef76d37
# ╟─dd30bcd0-939d-4907-b4e9-6a559a71426d
# ╟─82ba10db-c126-4355-9311-26c1d0ad707c
# ╟─22c5f11f-d1b0-4780-ae3d-eb0a5c7d5f14
# ╟─51ea0a30-8558-455b-81e3-79fbc8fe59e9
# ╟─8921aae4-2d39-4ddd-bf19-6b395253e488
# ╟─4ce2544f-c66d-4d56-a39d-fc7d5ee6d633
# ╟─f69d0a46-263e-4526-a8b2-ef4f4ee5b762
# ╟─68942dbc-0cdc-4201-a10e-bfbb2b56c73f
# ╟─8ffac44e-56cd-435e-be5c-d72e8be35941
# ╟─d6e02f5e-cb9e-440c-a335-a487db0d0930
# ╟─5b9336cd-e88d-478f-8711-bde0da5724be
# ╟─b401991e-ef32-4cee-8630-d9f54635aec3
# ╟─0dee4432-9118-428a-9b49-ca2648e14fcd
# ╟─6e529940-7f36-4bdd-8adb-1f34b2825d32
# ╟─be39cbe4-9b57-4827-b649-45655cb49270
# ╟─27a48326-0265-4334-b7cd-0c2fe3595999
# ╟─9ffda585-493f-4ffe-b360-dcf1420f107c
# ╟─2533a3d3-d368-4036-bea4-79645fe9adf2
# ╟─19eceb43-c982-4e99-a9d4-de229ac948e7
# ╟─636cdd0c-88c9-4c5a-833a-db2a49014c75
# ╟─29718094-db53-434b-ae91-5d93d06d857b
# ╟─e4458558-d2be-4d88-82cc-db1335c49aa8
# ╟─89646676-3a58-437b-ba49-df1732b43ba7
# ╟─19706e83-7306-4383-ac7f-55346d977d6e
# ╟─688eae45-6d4f-467a-a00b-911355528f66
# ╟─38b29bc7-bd8c-4fe8-bc1a-17e3dc6c79f5
# ╟─d320b509-675c-45a8-8b75-bdc449bbc6fe
# ╟─71606cb8-7ed2-4a70-b229-017cc0d21714
# ╟─53c77ef1-899d-47c8-8a30-ea38380d1614
# ╟─670e45a3-9d28-47ae-a6b6-a1b1c67a0a4c
# ╟─2ee2c328-5ebe-488e-94a9-2fce2200484c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
