### A Pluto.jl notebook ###
# v0.17.3

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

# ╔═╡ f0545c67-5cfd-438f-a9ef-92c35ebaefa4
#Set-up packages
begin
	
	using DataFrames, HTTP, CSV, Dates, Plots, PlutoUI, Printf, LaTeXStrings, HypertextLiteral
	
	gr();
	Plots.GRBackend()


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

# ╔═╡ 41d7b190-2a14-11ec-2469-7977eac40f12
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
	<p align=center style="font-size:25px; font-family:family:Georgia"> Winter 2022 <p>
	<p style="padding-bottom:1cm"> </p>
	<div align=center style="font-size:20px; font-family:family:Georgia"> Prof. Matt Fleckenstein </div>
	<p style="padding-bottom:0.0cm"> </p>
	<div align=center style="font-size:20px; font-family:family:Georgia"> University of Delaware, 
	Lerner College of Business and Economics </div>
	<p style="padding-bottom:0.5cm"> </p>
	"""
end

# ╔═╡ 6498b10d-bece-42bf-a32b-631224857753
md"""
# Overview
"""

# ╔═╡ 95db374b-b10d-4877-a38d-1d0ac45877c4
begin
	html"""
	<fieldset>      
        <legend>Outline</legend>      
		<br>    
		<input type="checkbox" value="">Introduction to the U.S. Treasury Securities Market<br><br>
	    <input type="checkbox" value="">Treasury Notes and Bonds<br><br>
		<input type="checkbox" value="">Treasury STRIPS<br><br>	
		<input type="checkbox" value="">Treasury TIPS<br><br>
	</fieldset>      
	"""
end

# ╔═╡ d2908a7c-51af-431c-ac09-4a7d89dbf02f
TableOfContents(aside=true, depth=1)

# ╔═╡ 588125ae-e790-4b05-8564-5062d7a556fe
md"""
# The U.S. Treasury Market
- The Department of the Treasury is the largest single issuer of debt in the world.
- The large volume of total debt and the large size of any single issue have contributed to making the Treasury market the most active and hence the most liquid market in the world


[SIFMA Fixed Income Statistics](https://www.sifma.org/resources/research/fixed-income-chart)
"""

# ╔═╡ 1539816e-2a47-4ae4-a2a3-7892958cc3ef
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/TreasuryOutstandingSIFMA.svg",:width => 900)

# ╔═╡ 014f362b-ccbb-41ba-ba87-08df662378a4
md"""
[Link to SIFMA](https://www.sifma.org/resources/research/fixed-income-chart/)
"""

# ╔═╡ e88bfd0b-83b0-4804-88bf-f95ad53fbb17
md"""
## Types of Treasury Securities
"""

# ╔═╡ e991ab0b-f2e9-403b-a157-c382268ae80b
md"""
## Treasury Bill (T-Bill)
- Short-term securities with maturities of 4, 13, 26, and 52 weeks.
- Treasury bills do not pay interest before maturity.
  - This is often referred to as a _discount security_ or _zero-coupon security_.
- Instead, Treasury bills are issued at a price less than their par value and at maturity, Treasury bills pay back their par value.
  - Intuitively, the “interest” to the investor is the difference between par value and the purchase price.
  - Example: a 52-week T-bill with par value of \$100 has a price of \$98.
"""

# ╔═╡ 794a93d4-b1b5-4fa6-8d58-14089c5935d9
md"""
## Treasury Note (T-Note)
- Medium-term securities with maturities of 2, 3, 5, 7, and 10 years.
- Treasury notes pay interest every six months up to and including the maturity date.
  - Example: A 2-year T-note has its last interest payment in two years, and it pays interest after 6 months, 12 months, and 18 months.
- At maturity, Treasury notes pay back their par value.
"""

# ╔═╡ b2e3d6ae-714b-421c-b7c5-e888e8799126
md"""
## Treasury Bond (T-Bond)
- Long-term securities with maturities of 20 and 30 years.
  - Currently, the Treasury does not issue 15-year Treasury bonds.
- Treasury bonds notes pay interest every six months up to and including the maturity date. At maturity, Treasury notes pay back their par value.
  - Similar to Treasury notes.

[Link to Treasury Marketable Securities](https://www.treasurydirect.gov/instit/marketables/marketables.htm)
"""

# ╔═╡ 39810523-c2db-44df-a79d-86944b5e9782
md"""
## Coupon bonds
- Treasury notes and bonds are referred to as **coupon** securities. Why?
"""

# ╔═╡ 442528d3-e052-4c1c-b715-f137f00c39e7
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/TreasuryCouponPicture.svg",:width => 900)

# ╔═╡ b145eb3f-bf7a-4b22-ab1c-7ecf7c16c54e
md"""
##
"""

# ╔═╡ 13fe3b83-f41e-4df6-8241-9621dae2e432
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/TreasuryNoteDescrExampleBloomberg.png",:width => 900)

# ╔═╡ 949f92b6-dd65-43cb-9b5d-c5c7e728ddb6
md"""
##
"""

# ╔═╡ 7cc4e9fe-ce39-492e-9b91-5b02d5f48e8d
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/TreasuryNoteCashflowExampleBloomberg.png",:width => 900)

# ╔═╡ 516b4ddb-887c-4292-bc1d-5c7f93bbe88d
md"""
## Treasury STRIPS

- The Treasury does not issue zero-coupon notes or bonds.
- However, because of the demand for zero-coupon instruments with no credit risk, the private sector has created such securities.
- The process of separating the interest on a bond from the underlying principal is called coupon stripping
- Zero-coupon Treasury securities were first created in August 1982 by large Wall-Street firms.
  - The problem with these securities was that they were identified with particular dealers and therefore reduced liquidity.
  - Moreover, the process involved legal and insurance costs. 
  - Today, all Treasury notes and bonds (fixed-principal and inflation-indexed) are eligible for stripping. 
- The **zero-coupon** Treasury securities created under the STRIPS program are direct obligations of the U.S. government
"""

# ╔═╡ b988449f-0ad2-4cae-b4ab-230cf5edaf60
md"""
## Treasury Floating Rate Note (FRN)
- First issued in 2014 by the U.S. Treasury.
- Maturity of 2 years.
- Pay interest every three months up to and including the maturity date.
  - At maturity, FRNs pay back their par value.
- The interest on an FRN varies with interest rate on 13-week Treasury bills.
"""

# ╔═╡ ffa772e6-8e12-4780-b079-debb7e995f6c
md"""
## Treasury Inflation Protected Securities (TIPS)
- First issued in 1997 by the U.S. Treasury.
- Maturities of 5, 10, and 30 years.
- TIPS pay interest every six months up to and including the maturity date. At maturity, Treasury notes pay back their par value.
  - Similar to Treasury notes and bonds.
- Key difference is that the par value of a TIPS goes up with the rate of inflation.

[Link to Treasury](https://www.treasurydirect.gov/indiv/products/prod_tips_glance.htm)
"""

# ╔═╡ 31c6387f-6a78-47dc-accc-f0eee3996edd
md"""
##
"""

# ╔═╡ f3963af9-c276-4423-b724-b01de1983c0d
#US Treasury Market
begin
	TreasMkt = DataFrame()
	plot_Treas = plot()
	let
		data_url = "https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/US-Treasury-Securities-Statistics-SIFMA_Outstanding.csv"
		my_file = CSV.File(HTTP.get(data_url).body; missingstring="-999")
		# my_file = CSV.File("./Assets/US-Treasury-Securities-Statistics-SIFMA_Outstanding.csv")
 		TreasMkt = DataFrame(my_file)
		
		transform!(TreasMkt, [:Notes,:Bonds] => (+) => :NotesAndBonds)
		transform!(TreasMkt, 
		  [:TIPS, :Total] => ByRow( (x,y)->any(ismissing.([x,y])) ? 
		 		missing :  (x/y*100)) => :TIPSPctTreas)
		
		minX = 1997
		maxX = 2020
		minY = 0.0
		maxY = 2000.0
		plot!(plot_Treas, TreasMkt.Year,TreasMkt.TIPS, 
		  	xlim=(minX,maxX), ylim=(minY, maxY), 
		  	ylabel="Billions of Dollars",label="TIPS",
		  	legend = :topleft, title="Amount Outstanding",right_margin = 15Plots.mm)	
		subplot=twinx()
		plot!(subplot, TreasMkt.Year,TreasMkt.TIPSPctTreas, color=:red,
			xlim=(minX,maxX), ylim=(0,20), ylabel = "Percent", 
			yticks=(0:5:20),label = "TIPS to Treasury Debt")	
		plot(plot_Treas)
	end
end

# ╔═╡ 144cfebc-b1ee-46bb-8ccd-a538e9bd9e19
md"""
# Inflation-Linked Securities
"""

# ╔═╡ 6e957b4b-4a27-4bc9-9fe4-e85052bfdda4
md"""
## Historical Background
"""

# ╔═╡ 3b399844-b41b-4c7a-abe5-8238a1ab22bf
md"""
- There is a long history of countries issuing inflation-linked debt. 
"""

# ╔═╡ 210e432f-4c5f-41d9-a593-d8452b56cef5
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/SoldiersDepreciationNote.png",:width => 900)

# ╔═╡ 35e52c31-80d0-4876-a0ed-2ced82592fd0
md"""
##
"""

# ╔═╡ 9f8eccc3-5303-4a19-b51a-ba9bd9475d49
md"""
> Both Principal and Interest to be paid in the then current Money of said State, in a greater or less Sum, according as Five Bushels of Corn, Sixty-eight Pounds and four-seventh Parts of a Pound of Beef, Ten Pounds of Sheeps Wool, and Sixteen Pounds of Sole Leather shall then cost more or less than One Hundred and Thirty Pounds current Money, at the then current Prices of said Articles.
_Source: “Inflation-indexed Securities: Bonds, Swaps and Other Derivatives”, 2nd Edition, M. Deacon, A. Derry, D. Mirfendereski, Wiley._


"""

# ╔═╡ 8419226c-198f-4fe8-8259-bb49b7cbc8e5
md"""
##
"""

# ╔═╡ 455197c6-65c2-4aba-a755-c1c7fd604a7e
md"""
Emerging market countries started to issue inflation-linked bonds in the 1950s. 
- Much later, the United Kingdom’s Debt Management Office followed suit with the first inflation-linked gilt issue in 1981, followed by Australia, Canada, and Sweden. 
- The U.S. Treasury only started issuing Treasury Inflation-Protected Securities (TIPS) in **1997**. 
- Currently, France, Germany, and Italy are frequent issuers of inflation-linked bonds in the Euro area. Japan recently started issuing inflation-linked bonds again. Australia, Brazil, Canada, Chile, Israel, Mexico, Turkey, and South Africa also issue substantial amounts of inflation-linked bonds.
"""

# ╔═╡ b377eec4-0433-48ec-960d-5e59d8696ced
md"""
## Index-Linked Bonds
"""

# ╔═╡ 01dd6da6-5c07-4c65-b403-c322961e638e
md"""
- Treasury Inflation-Protected Securities (TIPS) are _index-linked_ bonds.
  - An index-linked bond is one whose _cash flows_ are linked to movements in a specific price index.
- The _principal amount_ of a TIPS is indexed to the price level. 
  - Since a fixed coupon rate is applied to the principal that varies with the price level, the actual coupon cash flows vary in response to the realized rate of inflation.
- Index-linked bonds are usually indexed to a broad measure of prices, typically a domestic _Consumer Price Index (CPI)_.
"""

# ╔═╡ 796c0dc9-fd6a-4519-b9ba-5c2b730b27bc
md"""
## U.S. Consumer Price Index
- In the U.S. this price index is the Consumer Price Index for All Urban Consumers (_CPI-U_).
- The CPI-U measures the level of prices paid by consumers for goods and services. 
- This index is published by the Bureau of Labor Statistics (BLS) every month.
- [Bureau of Labor Statistics](https://www.bls.gov/schedule/news_release/cpi.htm); [Bureau of Labor Statistics Release](https://www.bls.gov/news.release/pdf/cpi.pdf)
"""

# ╔═╡ 03de2578-dff5-4b26-ad75-84c92fab1603
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/USCPIYoY.svg",:width => 900)

# ╔═╡ 414f4a76-f3dd-436f-a07a-b38a377c61a0
md"""
Source: [BLS.gov](https://www.bls.gov/charts/consumer-price-index/consumer-price-index-by-category-line-chart.htm)
"""

# ╔═╡ 203f3298-da56-4b30-b246-ebf571b3caad
md"""
##
"""

# ╔═╡ 0bfd0309-672c-4926-b2e2-673add7662f4
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/USCPI_ReleaseSchedule.svg",:width => 600)

# ╔═╡ 8c0edbf0-9767-4690-8af5-92c681327932
md"""
##
"""

# ╔═╡ 458e8893-c76f-4a69-8e15-07974f5c5397
md"""
### Inflation Adjustment

- A simple example is useful at this stage to clarify the concepts. 
- Suppose that an investor is faced with the choice between two instruments with the same maturity: 
  - Conventional bond yielding a _nominal_ yield of 5% 
  - Index-linked bond offering a _real_ yield of 3%. 
- The market’s valuations of these two bonds would imply that inflation is expected to be of the order of 2% per annum over their lifetime (5% - 3%=2%). 
- If the rate of inflation actually turns out to be higher at, say, 4% on average, then at maturity the indexed bond will have generated a 3% real return (precisely as expected). 
- The conventional bond’s 5% nominal return will have been eroded such that its ex post real yield is only 1%. 
- Of course, the reverse could occur instead. 
  - Suppose inflation turns out to be lower on average than had been expected at, say, 1%, then the conventional bond’s real return would turn out to be 4%, while that on the indexed bond would still have been 3%.
"""

# ╔═╡ 68e4fc51-7e44-469e-bb5a-ea562224c51e
md"""
## TIPS Inflation-Adjustment Basics
"""

# ╔═╡ 1a217214-86c3-4cde-9613-e2e2d6f85e71
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/TIPSInflationAdjustment.svg",:width => 900)

# ╔═╡ 52c01f5f-75fa-4195-bc77-9ab4613f4926
md"""
## TIPS Inflation Adjustment
"""

# ╔═╡ 0184f6a2-578c-49a0-a532-34c1d322d1ea
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/ReferenceCPI_Des.png",:width => 900)

# ╔═╡ 4cef58be-71eb-46cb-9480-da49feecaaae
md"""
##
"""

# ╔═╡ be17325c-713b-4df1-a4bd-ad80942e0860
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/ReferenceCPI_Graph.png",:width => 900)

# ╔═╡ 7e0b8581-deb2-42d9-baa9-ccff7db60448
md"""
## TIPS Inflation Adjustment Details

- The principal amount of a TIPS (assume $100 at issuance) is adjusted daily based on the CPI-U. 
- The inflation adjustment $I_t$ is computed as the ratio of the **Reference CPI** at the time $t$ divided by the reference CPI when the TIPS was first issued ($t=0$). 
$$I_t = \frac{\textrm{Reference CPI at time } t}{\textrm{Reference CPI at TIPS issue date}}$$

- The **Reference CPI** for a particular date $t$ during a month is linearly interpolated from the **Reference CPI** for the beginning of that month and the **Reference CPI** for the beginning of the subsequent month.
  - The **Reference CPI** for the first day of _any_ calendar month is the CPI-U index for the third preceding calendar month. 
  - _Example 1_: the **Reference CPI** for _April 1_ is the CPI-U index for the month of _January_ (which is reported by the BLS during February).
  - _Example 2_: the **Reference CPI** for _April 15_ is roughly the average of the CPI-U index for the month of _January_ and the CPI-U index for the month of February.
- However, the dollar value of the TIPS principal value is bounded below at $100, its value at issuance. Hence, TIPS offer some deflation protection.

"""

# ╔═╡ e8f85d65-66f8-4ddd-9d3c-7e798848f7f3
md"""
##
"""

# ╔═╡ d1f23485-74dc-4d86-9f8f-490a8345cd4c
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/IndexationLag_Chart.svg",:width => 900)

# ╔═╡ 78ef0e36-b989-45f9-a43e-305e612d02fc
md"""
## Reference CPI Caluclation Example for January 25, 1997
- To find the **Reference CPI** for any date in Janurary 1997, we first find the **Reference CPI** index levels for January 1, 1997 and for February 1, 1997.
  - The **Reference CPI** level is the US CPI-U index from three months prior.
  - For January this is the CPI-U from October 1996 (published by the BLS in November) and for February this is the CPI-U from November 1996 (published by the BLS in December).
- Then, take the difference between the two index CPI-U index levels and divide by it by the actual number of days in the month.  
- Next, multiply the result by the number of the day for which the **Reference CPI** is to be calculated and subtract 1.
  - For example, January 7 would be 6. January 25 is 24.
- Finally, add this result to the January 1st, CPI-U index level.
"""

# ╔═╡ 561ef352-71e7-4394-8d84-a5bc95fddff2
md"""
##
"""

# ╔═╡ 2749f2c5-291d-40cb-aff4-42ddc75ebaef
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/RefCPICalc1997.png",:width => 900)

# ╔═╡ 1b7bb9e9-5877-4b37-b2b7-d3b65b54fa78
md"""
##
"""

# ╔═╡ 5e5e6d9b-29b0-425c-a53d-136cd1968c90
md"""
> Jan 1 level = 158.3

> Feb 1 level = 158.6 

> 158.6 - 158.3 = .30 

> .30/31 days = .0096774 (there are 31 days in January)

> .0096774 $\times$ 6 = .05806 

> CPI-U for Jan 7 = 158.3 + .05806 = 158.35806. 
"""

# ╔═╡ d078baa7-265f-4d7a-b8ff-5ac65e790bb8
md"""
## Inflation Adjustment 
"""

# ╔═╡ 632909cd-59be-4e5a-93aa-2f6953723701
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/of698cpi_crop.svg",:width => 500)

# ╔═╡ efed7be3-fa6f-487c-9474-bd27b0ea4217
md"""
- The Reference CPI is then turned into a ratio to caclulate the inflation adjustment by taking the Reference CPI on the date and dividing by the Reference CPI at issue. 
  - For example, CPI-U for Jan 15, the official issue date of the inaugural TIPS bond is 158.43548. 
  - The CPI-U for Jan 25 is 158.53226.
> The inflation adjustment factor for Jan 25 is 158.53226/158.43458 = 1.00061

"""

# ╔═╡ 9ca43519-78c5-4030-9fc2-b5510aab7533
md"""
## Deflation Protection
- TIPS have an embedded option that protects against deflation.
- The Treasury guarantees that the _final redemption value is no less than \$100 per \$100 nominal_ amount, irrespective of the movements in the CPI over the life of the bond.
- Let $F$ be the TIPS principal amount and $T$ the time to maturity of the TIPS.
- The principal cash flow at maturity $T$ is
$$F \times \max\left[\, I_T, 1 \,\right]$$
- This deflation protection does not apply to coupon cash flows.
"""

# ╔═╡ 07785069-79df-484a-ab77-a06dee70b5aa
md"""
## Example
"""

# ╔═╡ 140bcc39-510b-4a6f-95df-2c49ae4bc22d
md"""
- Let $F$ be the TIPS principal value.
- Let $c$ denote the (fixed) _real_ coupon rate on the TIPS.
- Let $T$ denote the time to maturity of the TIPS (in years).

"""

# ╔═╡ 1d480c48-6fec-4860-811d-bb8216f9bfc7
md"""
- Principal $F$ [$]: $(@bind F Slider(100:100:1000, default=100, show_value=true))
- Real Coupon Rate c [%]: $(@bind c Slider(0:0.25:10, default=3, show_value=true))
- Time to Maturity $T$ [years]: $(@bind T Slider(1:1:30, default=5, show_value=true))
- Reference CPI at issue date: $(@bind I₀ Slider(100:1:300, default=100, show_value=true))
"""

# ╔═╡ a2397907-859c-41a1-ad65-e893c883a746
Markdown.parse("
- Suppose, \$c= $c \\%\$ and \$F=$F\$.
- In real terms, the coupon cash flows at each coupon date are 
		
\$\\frac{c}{2} \\, F = \\frac{$(c/100)}{2} \\, $F = $(c/200*F)\$
	
- Suppose there is inflation (or deflation).
- The actual cash flows (in nominal terms) of the TIPS are:
")


# ╔═╡ 20e690fc-cd96-4232-88c2-15a729ac7faf
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

# ╔═╡ 2b8f6d8c-cfe4-4d39-aa43-9c043248c995
md"""
# Inflation Derivatives
In addition to the cash inflation market, there is an active derivatives market that consists mainly of inflation swap contracts and inflation options. The inflation swap market in the United States is growing rapidly.
"""

# ╔═╡ 00537229-bc9a-41fb-aeee-4798a24d424c
md"""
## Inflation Swap
"""

# ╔═╡ d57dc159-839d-4122-bb87-b5d683d37184
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/InflSwap_Chart.svg",:width => 400)

# ╔═╡ c21420d1-4b77-468d-86d4-a4c56de6a80b
md"""
##
"""

# ╔═╡ 2f5a3344-ff86-4aef-9f80-a9e1dcf017b1
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/InflSwap1Yr_Des.png",:width => 900)

# ╔═╡ 010b64c5-1f30-4631-9c3f-a18ce981cd25
md"""
##
"""

# ╔═╡ 3e00ebce-d205-4e5e-9926-be3cc4c91623
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/InflSwap1Yr_PxQuotes.png",:width => 900)

# ╔═╡ a7203e20-8aea-41c3-9e80-b77bd275b4e5
md"""
##
"""

# ╔═╡ 3168837d-cdf2-41a2-8240-191abd824304
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/InflSwap1Yr_Graph.png",:width => 900)

# ╔═╡ 8b590adc-a0c8-495a-a819-2fede8f1770d
md"""
## Inflation Swap Cash Flows
"""

# ╔═╡ db493987-cc0d-41dc-8a86-697e636491a7
md"""
- The swap is executed between two counterparties at time $t=0$ and has only one cash flow that occurs at maturity in $T$ years.
  - For example, imagine that at time $t=0$, the five-year zero-coupon inflation swap rate is 200 basis points and that the inflation swap has a notional of \$1. 
  - There are no cash flows at time $t=0$ when the swap is executed. 
  - At the maturity of the swap in $T=5$ years, suppose that realized inflation is $I_T$, then the counterparties to the inflation swap exchange a cash flow of 

$$\left[ (1 + 0.0200)^5 -1 \right] − \left[I_T -1 \right],$$

- Thus, if the realized inflation rate was 1.50% per year over the five-year horizon of the swap, 

$$I_T = 1.015^5 = 1.077284$$ 

- In this case, the net cash flow per \$1 notional of the swap from the swap would be 


$$\left[ (1 + 0.0200)^5 -1\right] − \left[1.077284 -1 \right]= 0.026797$$ 
"""

# ╔═╡ 1b44275b-fc25-433a-8107-2c3f0f590160
md"""
##
"""

# ╔═╡ 1e67a9c9-a676-4586-bbbf-b278389e4890
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/InflationSwap_TermSheet.svg",:width => 900)

# ╔═╡ 9d89b0b7-3c74-439e-886c-24d8940c4d1d
md"""
## Example
"""

# ╔═╡ 8d54c511-b8ae-4b9b-80ff-5c9269dd2fde
md"""
- Notional $N$ [$]: $(@bind Nswap Slider(100:100:1000, default=100, show_value=true))
- Inflation Swap Rate $f$ [%]: $(@bind fswap Slider(0:0.25:10, default=3, show_value=true))
- Time to Maturity $T$ [years]: $(@bind Tswap Slider(1:1:30, default=5, show_value=true))
- Annual Inflation Rate $I$ [%]: $(@bind Iswap Slider(0:0.25:10, default=2, show_value=true))
"""

# ╔═╡ 8e347b20-8f10-4c36-8d74-03364fdc683b
Markdown.parse("
- Cash flow on the fixed leg of the inflation swap:

\$N \\times \\left[ (1+f)^T - 1 \\right] = $(Nswap) \\times \\left[ (1+ $(fswap/100))^{$(Tswap)} -1 \\right]= $(Nswap*( (1+fswap/100)^Tswap -1))\$
	
- Cash flow on the floating leg of the swap:
	
\$N \\times \\left[ (1+I)^T - 1 \\right]]= $(Nswap) \\times \\left[ (1+$(Iswap/100))^{$(Tswap)} - 1 \\right]=$(Nswap*((1+Iswap/100)^Tswap-1))\$
	
- Net cash flow of inflation buyer: $(Nswap*(1+Iswap/100)^Tswap - Nswap*(1+fswap/100)^Tswap)
")


# ╔═╡ 53c77ef1-899d-47c8-8a30-ea38380d1614
md"""
## Wrap-Up
"""

# ╔═╡ 670e45a3-9d28-47ae-a6b6-a1b1c67a0a4c
begin
	html"""
	<fieldset>      
        <legend>Outline</legend>      
		<br>    
		<input type="checkbox" value="" checked>U.S. Treasury Securities Market<br><br>
	    <input type="checkbox" value="" checked>Treasury Notes and Bonds<br><br>
		<input type="checkbox" value="" checked>Treasury STRIPS<br><br>	
		<input type="checkbox" value="" checked>Treasury TIPS<br><br>
	</fieldset>      
	"""
end

# ╔═╡ 6d106a0e-5473-4000-bed9-e26c44a2c715
md"""
##
"""

# ╔═╡ 2ee2c328-5ebe-488e-94a9-2fce2200484c
md"""
#### Reading: 
Fleckenstein, Matthias, Francis A. Longstaff, and Hanno Lustig, 2014, The TIPS–Treasury Bond Puzzle, Journal of Finance, Volume 69, Issue 5, 2014, 2151–2197.

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
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[compat]
CSV = "~0.9.11"
DataFrames = "~1.2.2"
HTTP = "~0.9.17"
HypertextLiteral = "~0.9.3"
LaTeXStrings = "~1.3.0"
Plots = "~1.22.4"
PlutoUI = "~0.7.15"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings"]
git-tree-sha1 = "49f14b6c56a2da47608fe30aed711b5882264d7a"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.9.11"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "a851fec56cb73cfdf43762999ec72eff5b86882a"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.15.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "31d0151f5716b655421d9d75b7fa74cc4e744df2"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.39.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d785f42445b63fc86caa08bb9a9351008be9b765"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.2.2"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "04d13bfa8ef11720c24e4d840c0033d145537df7"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.17"

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

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "0c603255764a1fa0b61752d2bec14cfbd18f7fe8"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+1"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "c2178cfbc0a5a552e16d097fae508f2024de61a3"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.59.0"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "cafe0823979a5c9bff86224b3b8de29ea5a44b2e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.61.0+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

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

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "8d70835a3759cdd75881426fced1508bb7b7e1b6"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.1.1"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

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
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a4b12a1bd2ebade87891ab7e36fdbce582301a92"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.6"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

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
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "5a5bc6bf062f0f95e62d0fe0a2d99699fed82dd9"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.8"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "a8709b968a1ea6abc2dc1967cb1db6ac9a00dfb6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.5"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "b084324b4af5a438cd63619fd006614b3b20b87b"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.15"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs"]
git-tree-sha1 = "6841db754bd01a91d281370d9a0f8787e220ae08"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.22.4"

[[PlutoUI]]
deps = ["Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "633f8a37c47982bff23461db0076a33787b17ecd"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.15"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a193d6ad9c45ada72c14b731a318bedd3c2f00cf"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.3.0"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "69fd065725ee69950f3f58eceb6d144ce32d627d"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "44a75aa7a527910ee3d1751d1f0e4148698add9e"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.2"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "7ad0dfa8d03b7bcf8c597f59f5292801730c55b8"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.4.1"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "244586bc07462d22aed0113af9c731f2a518c93e"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.10"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8cbbc098554648c84f79a463c9ff0fd277144b6c"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.10"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "2ce41e0d042c60ecd131e9fb7154a3bfadbf50d3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.3"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll"]
git-tree-sha1 = "2839f1c1296940218e35df0bbb220f2a79686670"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.18.0+4"

[[WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "c69f9da3ff2f4f02e811c3323c22e5dfcb584cfa"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.1"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

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

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

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
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

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
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─41d7b190-2a14-11ec-2469-7977eac40f12
# ╠═f0545c67-5cfd-438f-a9ef-92c35ebaefa4
# ╠═731c88b4-7daf-480d-b163-7003a5fbd41f
# ╟─a5de5746-3df0-45b4-a62c-3daf36f015a5
# ╟─6498b10d-bece-42bf-a32b-631224857753
# ╟─95db374b-b10d-4877-a38d-1d0ac45877c4
# ╟─d2908a7c-51af-431c-ac09-4a7d89dbf02f
# ╟─588125ae-e790-4b05-8564-5062d7a556fe
# ╟─1539816e-2a47-4ae4-a2a3-7892958cc3ef
# ╟─014f362b-ccbb-41ba-ba87-08df662378a4
# ╟─e88bfd0b-83b0-4804-88bf-f95ad53fbb17
# ╟─e991ab0b-f2e9-403b-a157-c382268ae80b
# ╟─794a93d4-b1b5-4fa6-8d58-14089c5935d9
# ╟─b2e3d6ae-714b-421c-b7c5-e888e8799126
# ╟─39810523-c2db-44df-a79d-86944b5e9782
# ╠═442528d3-e052-4c1c-b715-f137f00c39e7
# ╟─b145eb3f-bf7a-4b22-ab1c-7ecf7c16c54e
# ╟─13fe3b83-f41e-4df6-8241-9621dae2e432
# ╟─949f92b6-dd65-43cb-9b5d-c5c7e728ddb6
# ╟─7cc4e9fe-ce39-492e-9b91-5b02d5f48e8d
# ╟─516b4ddb-887c-4292-bc1d-5c7f93bbe88d
# ╟─b988449f-0ad2-4cae-b4ab-230cf5edaf60
# ╟─ffa772e6-8e12-4780-b079-debb7e995f6c
# ╟─31c6387f-6a78-47dc-accc-f0eee3996edd
# ╟─f3963af9-c276-4423-b724-b01de1983c0d
# ╟─144cfebc-b1ee-46bb-8ccd-a538e9bd9e19
# ╟─6e957b4b-4a27-4bc9-9fe4-e85052bfdda4
# ╟─3b399844-b41b-4c7a-abe5-8238a1ab22bf
# ╟─210e432f-4c5f-41d9-a593-d8452b56cef5
# ╟─35e52c31-80d0-4876-a0ed-2ced82592fd0
# ╟─9f8eccc3-5303-4a19-b51a-ba9bd9475d49
# ╟─8419226c-198f-4fe8-8259-bb49b7cbc8e5
# ╟─455197c6-65c2-4aba-a755-c1c7fd604a7e
# ╟─b377eec4-0433-48ec-960d-5e59d8696ced
# ╟─01dd6da6-5c07-4c65-b403-c322961e638e
# ╟─796c0dc9-fd6a-4519-b9ba-5c2b730b27bc
# ╟─03de2578-dff5-4b26-ad75-84c92fab1603
# ╟─414f4a76-f3dd-436f-a07a-b38a377c61a0
# ╟─203f3298-da56-4b30-b246-ebf571b3caad
# ╟─0bfd0309-672c-4926-b2e2-673add7662f4
# ╟─8c0edbf0-9767-4690-8af5-92c681327932
# ╟─458e8893-c76f-4a69-8e15-07974f5c5397
# ╟─68e4fc51-7e44-469e-bb5a-ea562224c51e
# ╟─1a217214-86c3-4cde-9613-e2e2d6f85e71
# ╟─52c01f5f-75fa-4195-bc77-9ab4613f4926
# ╟─0184f6a2-578c-49a0-a532-34c1d322d1ea
# ╟─4cef58be-71eb-46cb-9480-da49feecaaae
# ╟─be17325c-713b-4df1-a4bd-ad80942e0860
# ╟─7e0b8581-deb2-42d9-baa9-ccff7db60448
# ╟─e8f85d65-66f8-4ddd-9d3c-7e798848f7f3
# ╟─d1f23485-74dc-4d86-9f8f-490a8345cd4c
# ╟─78ef0e36-b989-45f9-a43e-305e612d02fc
# ╟─561ef352-71e7-4394-8d84-a5bc95fddff2
# ╟─2749f2c5-291d-40cb-aff4-42ddc75ebaef
# ╟─1b7bb9e9-5877-4b37-b2b7-d3b65b54fa78
# ╟─5e5e6d9b-29b0-425c-a53d-136cd1968c90
# ╟─d078baa7-265f-4d7a-b8ff-5ac65e790bb8
# ╟─632909cd-59be-4e5a-93aa-2f6953723701
# ╟─efed7be3-fa6f-487c-9474-bd27b0ea4217
# ╟─9ca43519-78c5-4030-9fc2-b5510aab7533
# ╟─07785069-79df-484a-ab77-a06dee70b5aa
# ╟─140bcc39-510b-4a6f-95df-2c49ae4bc22d
# ╟─1d480c48-6fec-4860-811d-bb8216f9bfc7
# ╟─a2397907-859c-41a1-ad65-e893c883a746
# ╟─20e690fc-cd96-4232-88c2-15a729ac7faf
# ╟─2b8f6d8c-cfe4-4d39-aa43-9c043248c995
# ╟─00537229-bc9a-41fb-aeee-4798a24d424c
# ╟─d57dc159-839d-4122-bb87-b5d683d37184
# ╟─c21420d1-4b77-468d-86d4-a4c56de6a80b
# ╟─2f5a3344-ff86-4aef-9f80-a9e1dcf017b1
# ╟─010b64c5-1f30-4631-9c3f-a18ce981cd25
# ╟─3e00ebce-d205-4e5e-9926-be3cc4c91623
# ╟─a7203e20-8aea-41c3-9e80-b77bd275b4e5
# ╟─3168837d-cdf2-41a2-8240-191abd824304
# ╟─8b590adc-a0c8-495a-a819-2fede8f1770d
# ╟─db493987-cc0d-41dc-8a86-697e636491a7
# ╟─1b44275b-fc25-433a-8107-2c3f0f590160
# ╟─1e67a9c9-a676-4586-bbbf-b278389e4890
# ╟─9d89b0b7-3c74-439e-886c-24d8940c4d1d
# ╟─8d54c511-b8ae-4b9b-80ff-5c9269dd2fde
# ╟─8e347b20-8f10-4c36-8d74-03364fdc683b
# ╟─53c77ef1-899d-47c8-8a30-ea38380d1614
# ╟─670e45a3-9d28-47ae-a6b6-a1b1c67a0a4c
# ╟─6d106a0e-5473-4000-bed9-e26c44a2c715
# ╟─2ee2c328-5ebe-488e-94a9-2fce2200484c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
