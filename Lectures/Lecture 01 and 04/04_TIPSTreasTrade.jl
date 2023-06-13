### A Pluto.jl notebook ###
# v0.19.26

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
# ╠═╡ show_logs = false
begin
	
	
	using Pkg
	#Pkg.upgrade_manifest()
	#Pkg.resolve()
	Pkg.update()
		
	using DataFrames, CSV, HTTP,  Dates, PlutoUI, Printf, LaTeXStrings, HypertextLiteral, PrettyTables, Luxor, ShortCodes
	
		
	using Plots
	gr(size=(800,400))
	# import PlotlyJS
	# plotlyjs()



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

# ╔═╡ 41d7b190-2a14-11ec-2469-7977eac40f12
#add button to trigger presentation mode
html"<button onclick='present()'>present</button>"

# ╔═╡ bb32ad39-8aaf-468c-a5c5-24b92cc2e622
begin 
	html"""
	<p align=left style="font-size:30px; font-family:family:Georgia"> <b> UD/ISCTE-IUL Trading and Bloomberg Program</b> <p>
	"""
end

# ╔═╡ a5de5746-3df0-45b4-a62c-3daf36f015a5
begin 
	html"""
	<p style="padding-bottom:1cm"> </p>
	<p align=center style="font-size:25px; font-family:family:Georgia"> <b> The TIPS-Treasury Bond Puzzle
	</b> <p>
	<p style="padding-bottom:1cm"> </p>
	<p align=center style="font-size:25px; font-family:family:Georgia"> June 2023 <p>
	<p style="padding-bottom:0.5cm"> </p>
	<div align=center style="font-size:20px; font-family:family:Georgia"> Prof. Matt Fleckenstein </div>
	<p style="padding-bottom:0.05cm"> </p>
	<div align=center style="font-size:20px; font-family:family:Georgia"> University of Delaware, 
	Lerner College of Business and Economics </div>
	<p style="padding-bottom:0.0cm"> </p>
	"""
end

# ╔═╡ 2f1a6f95-3c0d-4732-95f0-6cfbd8e880ec
vspace

# ╔═╡ 2ba2909e-d6f8-4847-ab98-83d848fe5273
TableOfContents(aside=true, depth=1)

# ╔═╡ dc087ad9-d06c-4e1b-a404-116f7c974475
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 1</div>
"""

# ╔═╡ 886da2d4-c1ec-4bb4-8733-e3b46c95dd36
md"""
# The TIPS-Treasury Bond Puzzle
"""

# ╔═╡ 6334202e-2047-4e7c-beca-020768340f08
md"""
## The Largest Arbitrage Ever Documented

> - _“... you can forget about the concept of picking up pennies in front of a steamroller because ... this **arbitrage** can run to as much **$20 per $100 notional amount**.”_\
> - _“The trade was Barnegat’s most profitable and saw the fund make an impressive **132 per cent return that year**, outpacing almost every other fund in the industry.”_

Sources: [The largest arbitrage ever documented](https://www.ft.com/content/3ec205b7-4351-3c0b-a46c-e23ab86c3a44); [Hedge funds reap rewards from Treasuries](https://www.ft.com/content/a5aa3c38-c111-11df-afe0-00144feab49a)
"""

# ╔═╡ 98f202ba-7720-40fd-b618-87bd30de840c
vspace

# ╔═╡ e6401d0b-1cfd-4e9e-b65c-66bc51405097
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 2</div>
"""

# ╔═╡ 410b6e69-0ebc-4e2f-9b07-48b7f112ab83
md"""
> - _**“For Barnegat the opportunity was clear: the fund bought TIPS bonds and went short on regular Treasury bonds of a matched maturity, hedging out the effect of inflation along the way with a swap contract.”**_ \
> - _“The result was a trade that would make money if the divergent prices between the two securities converged. The difference in price between the two securities narrowed sharply through 2009.”_\
> - _“ 'If 2009 was an excellent year, then 2010 is still a very good year. The opportunities are huge in some cases,' says Mr Treue. Indeed, Barnegat is up 15.75 per cent so far this year.”_

Source: [Hedge funds reap rewards from Treasuries](https://www.ft.com/content/a5aa3c38-c111-11df-afe0-00144feab49a)
"""

# ╔═╡ 8f8c2c95-25ef-4da0-afe1-b0a204911aeb
vspace

# ╔═╡ 313bf11c-1888-4e82-b600-38425d2afacd
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 3</div>
"""

# ╔═╡ 70e71241-e939-4b06-bcbe-ff7cf611df7a
md"""
[Presentation by Bob Treue, Fixed Income Arbitrage, Barnegat Fund Management](https://youtu.be/V-ssGaTnl8o)
"""

# ╔═╡ 3e8baccf-799d-4694-99b0-9612bc59928f
YouTube("V-ssGaTnl8o")

# ╔═╡ cf971833-a2fa-4d6b-880e-7c2a9de0ec7d
vspace

# ╔═╡ 6815d4d8-2085-4787-b16d-55ead8b0e91d
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 4</div>
"""

# ╔═╡ 355989df-4aab-4c82-9e43-67123e9aecee
md"""
## The TIPS-Treasury Bond Puzzle in the Journal of Finance
"""

# ╔═╡ 9185f93e-3503-4dff-8133-8afd36fe148b
md"""
> _"It’s contained in a great little paper published earlier this month and it isn’t a fancy, schmancy accessible to high frequency traders only type of trade."_

Source: [Kaminska (2010), FT.com](https://www.ft.com/content/3ec205b7-4351-3c0b-a46c-e23ab86c3a44)
"""

# ╔═╡ fce5cf58-d66c-4fde-b6bb-854f745d1935
vspace

# ╔═╡ ba12da13-8d22-44c0-a507-178e7f88c19b
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 5</div>
"""

# ╔═╡ 8fa726b4-7064-4bd3-a2fa-54d875593009
# ╠═╡ show_logs = false
LocalResource("./Assets/FleckensteinLongstaffLustig2014_Abstract.svg",:width => 900)

# ╔═╡ aa3d4c8c-2a9d-4e5a-b622-5424f341c8fb
vspace

# ╔═╡ d74fe545-371e-4c5d-bb31-8efaf2f10ddb
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 6</div>
"""

# ╔═╡ 675daf21-167e-43a2-b680-a905aaaf1563
md"""
## International Inflation-Linked Bond Puzzle
> - _Italian bond markets, for example, exhibited unprecedented price discrepancies between different classes of bond issued by the government as a result of the ECB’s LTRO liquidity injection._\
> - _In January, investors dumped inflation-protected Italian bonds, fearful that they would automatically drop out of key European bond indices if the country’s credit rating was downgraded, while at the same time Italian banks snapped up regular Italian bonds with LTRO cash._\
> - **_Hedge funds bought the cheap inflation-protected bonds, wrote swaps to offset inflation and then shorted expensive regular Italian bonds, thereby completely hedging out credit risk and inflation and locking in the supply and demand-driven difference between the two bonds._**\
> - _The spread between them was more than 200 basis points, according to Bob Treue, the founder of Barnegat, a US-based fixed income arbitrage hedge fund that has made 18 per cent on its investments so far this year._
Source: [ECB liquidity fuels high stakes hedging](https://www.ft.com/content/cb74d63a-7e75-11e1-b009-00144feab49a#axzz24lB77mEm)
"""

# ╔═╡ d1e728b2-55dd-424c-8264-c5d506570dcc
vspace

# ╔═╡ 5fff35ac-b1e2-4968-9fa0-56a38c1ffe26
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 7</div>
"""

# ╔═╡ 298dada3-f3a7-4ac1-bdaa-55be8b359e95
md"""
# Treasury Inflation Protected Securities (TIPS)
- First issued in 1997 by the U.S. Treasury.
- Maturities of 5, 10, and 30 years.
- TIPS pay interest every six months up to and including the maturity date. At maturity, Treasury notes pay back their par value.
  - Similar to Treasury notes and bonds.
- Key difference is that the par value of a TIPS goes up with the rate of inflation.

[Link to Treasury](https://www.treasurydirect.gov/indiv/products/prod_tips_glance.htm)
"""

# ╔═╡ 8a1d71d6-f740-469f-8ad5-8716b8390a36
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 8</div>
"""

# ╔═╡ dc307a3f-c258-49cd-bb46-499da5209f41
md"""
## The TIPS Market
"""

# ╔═╡ d6729dc9-0706-4405-9786-0da8ef96fe0a
#US Treasury Market
begin
	TreasMkt = DataFrame()
	plot_Treas = plot()
	let
		my_file = CSV.File("./Assets/US-Treasury-Securities-Statistics-SIFMA_Outstanding.csv")
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
		#plot(plot_Treas)
	end
end

# ╔═╡ 679a7467-6d3a-46e2-80b2-ef325ef97ea1
vspace

# ╔═╡ 1531daab-bfc7-43fb-a336-220d41663e6f
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 9</div>
"""

# ╔═╡ 3e5097fe-5a26-4326-bbcd-1ae95a163c02
md"""
## Historical Background
"""

# ╔═╡ 9e730ef8-2791-4fd7-bd07-8844cd3c2f69
md"""
- There is a long history of countries issuing inflation-linked debt. 
"""

# ╔═╡ fd4f618a-71f2-4976-8515-031e79df3e5b
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/SoldiersDepreciationNote.png",:width => 900)

# ╔═╡ 448aef9e-7b85-4b8f-ba40-7490513dfd1a
md"""
> Both Principal and Interest to be paid in the then current Money of said State, in a greater or less Sum, according as Five Bushels of Corn, Sixty-eight Pounds and four-seventh Parts of a Pound of Beef, Ten Pounds of Sheeps Wool, and Sixteen Pounds of Sole Leather shall then cost more or less than One Hundred and Thirty Pounds current Money, at the then current Prices of said Articles.
_Source: “Inflation-indexed Securities: Bonds, Swaps and Other Derivatives”, 2nd Edition, M. Deacon, A. Derry, D. Mirfendereski, Wiley._


"""

# ╔═╡ 8b9ac326-884f-4d49-bb09-b01cfa0ae9d3
vspace

# ╔═╡ 23e98ea2-bb02-4940-87f3-0a745d562204
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 10</div>
"""

# ╔═╡ 7e316df9-3c1d-47ca-96e7-e79984fc92cf
md"""
Emerging market countries started to issue inflation-linked bonds in the 1950s. 
- Much later, the United Kingdom’s Debt Management Office followed suit with the first inflation-linked gilt issue in 1981, followed by Australia, Canada, and Sweden. 
- The U.S. Treasury only started issuing Treasury Inflation-Protected Securities (TIPS) in **1997**. 
- Currently, France, Germany, and Italy are frequent issuers of inflation-linked bonds in the Euro area. Japan recently started issuing inflation-linked bonds again. Australia, Brazil, Canada, Chile, Israel, Mexico, Turkey, and South Africa also issue substantial amounts of inflation-linked bonds.
"""

# ╔═╡ 1f4a1481-b28f-4906-b1b3-15b192263b83
vspace

# ╔═╡ a97e8be6-9b30-4b2b-9f35-cb27c5353266
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 11</div>
"""

# ╔═╡ cb6d785c-235d-4c8a-935e-17628c13e850
md"""
## Indexing Bonds to Inflation
"""

# ╔═╡ 62c1c14e-7094-430a-bcff-74e298d6597e
md"""
- Treasury Inflation-Protected Securities (TIPS) are _index-linked_ bonds.
  - An index-linked bond is one whose _cash flows_ are linked to movements in a specific price index.
- The _principal amount_ of a TIPS is indexed to the price level. 
  - Since a fixed coupon rate is applied to the principal that varies with the price level, the actual coupon cash flows vary in response to the realized rate of inflation.
- Index-linked bonds are usually indexed to a broad measure of prices, typically a domestic _Consumer Price Index (CPI)_.
"""

# ╔═╡ 7dab91e9-e501-4fed-b5b1-cdc8ac6cdf6c
vspace

# ╔═╡ ee6ab1f4-82a5-47ed-a31a-49927cd0a762
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 12</div>
"""

# ╔═╡ abe6fa93-0105-43e5-9e03-92664b563b38
md"""
## U.S. Consumer Price Index
- In the U.S. this price index is the Consumer Price Index for All Urban Consumers (_CPI-U_).
- The CPI-U measures the level of prices paid by consumers for goods and services. 
- This index is published by the Bureau of Labor Statistics (BLS) every month.
- [Bureau of Labor Statistics](https://www.bls.gov/schedule/news_release/cpi.htm); [Bureau of Labor Statistics Release](https://www.bls.gov/news.release/pdf/cpi.pdf)
"""

# ╔═╡ da83e6fb-96b5-4741-a843-a1a58b1315ae
vspace

# ╔═╡ 2e5233cd-a187-4336-8df8-45c5c994af2e
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 13</div>
"""

# ╔═╡ 348219b8-8d4c-425b-8773-b42313554eef
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/USCPIYoY.svg",:width => 900)

# ╔═╡ 2ed83178-02a6-4e60-bd33-9df1a74b2f04
md"""
Source: [BLS.gov](https://www.bls.gov/charts/consumer-price-index/consumer-price-index-by-category-line-chart.htm)
"""

# ╔═╡ c3d5177e-5dc3-43da-a419-37b6e58ac49a
vspace

# ╔═╡ 64da17e3-7b28-4ae9-ae39-de5878cb5097
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 14</div>
"""

# ╔═╡ 34d8c7f7-0266-49c8-aac5-ac882d3beb48
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/USCPI_ReleaseSchedule.svg",:width => 600)

# ╔═╡ 87b62691-4e4d-4099-8650-651c92d9ef88
vspace

# ╔═╡ 4c08a00e-e4fb-4c21-8790-0fdc25b01175
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 15</div>
"""

# ╔═╡ 562de281-2571-4b1f-8363-fcbd02cb3204
md"""
## Inflation Adjustment Intuition

- A simple example is useful at this stage to clarify the concepts. 
- Suppose that an investor is faced with the choice between two instruments with the same maturity: 
  - Conventional bond yielding a _nominal_ yield of 5% 
  - Index-linked bond offering a _real_ yield of 3%. 
- The market’s valuations of these two bonds would imply that inflation is expected to be of the order of 2% per annum over their lifetime (5% - 3%=2%). 
"""

# ╔═╡ 444ab8c9-35b4-4bc5-bb0b-dc2410f4ccac
vspace

# ╔═╡ b8d65061-ed96-403e-9321-44adc76d6e91
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 16</div>
"""

# ╔═╡ 96519f0e-df82-4c03-9c34-bee6f7fd961c
md"""
- If the rate of inflation actually turns out to be higher at, say, 4% on average, then at maturity the indexed bond will have generated a 3% real return (precisely as expected). 
- The conventional bond’s 5% nominal return will have been eroded such that its ex post real yield is only 1%. 
- Of course, the reverse could occur instead. 
  - Suppose inflation turns out to be lower on average than had been expected at, say, 1%, then the conventional bond’s real return would turn out to be 4%, while that on the indexed bond would still have been 3%.
"""

# ╔═╡ 70bf8b77-680d-4b72-b912-4f44ecfe9a24
vspace

# ╔═╡ 24412bb5-edc2-4cfc-ab4e-77f6e2873012
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 17</div>
"""

# ╔═╡ 7a447118-1335-41a5-8f88-9f47a6637061
md"""
# TIPS Inflation-Adjustment
"""

# ╔═╡ f0b795bd-a6fe-4f80-8b65-f345a5aeb953
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/TIPSInflationAdjustment.svg",:width => 900)

# ╔═╡ 76204388-2bca-4054-a34c-218193d2d134
vspace

# ╔═╡ 807e7022-e410-40a2-9715-4bee4d7a86aa
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 18</div>
"""

# ╔═╡ dca49c6a-a897-442e-8924-7b171e806fc5
md"""
## Reference CPI
"""

# ╔═╡ b969b168-ec64-4a68-99bd-23b7067b0048
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/ReferenceCPI_Des.png",:width => 900)

# ╔═╡ 9ed05f91-a314-4e6c-b05c-8d372d0f2d0f
vspace

# ╔═╡ 030fafca-4e4c-44dc-a502-325dabe79cb0
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 19</div>
"""

# ╔═╡ 977ba39b-5e9d-4591-a5f0-3b6fc0b5fec4
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/ReferenceCPI_Graph.png",:width => 900)

# ╔═╡ 4c81d7cf-a79d-43ee-85b6-230ba1b7c6ed
vspace

# ╔═╡ 6966dc19-0cf1-43db-a84a-7eec99d63706
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 20</div>
"""

# ╔═╡ a0af3215-6ecc-4083-afaa-31c476ebae4a
md"""
## TIPS Inflation Adjustment Details

- The principal amount of a TIPS (assume $100 at issuance) is adjusted daily based on the CPI-U. 
- The inflation adjustment $I_t$ is computed as the ratio of the **Reference CPI** at the time $t$ divided by the reference CPI when the TIPS was first issued ($t=0$). 
$$I_t = \frac{\textrm{Reference CPI at time } t}{\textrm{Reference CPI at TIPS issue date}}$$

"""

# ╔═╡ 9b7aeb59-1592-4568-9152-d3e333317f95
vspace

# ╔═╡ 69d93c06-c1ac-40e9-8e34-ed0479514254
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 21</div>
"""

# ╔═╡ 015d265b-55a0-48a0-9878-b3e71b591931
md"""
- The **Reference CPI** for the first day of _any_ calendar month is the CPI-U index for the third preceding calendar month. 
- The **Reference CPI** for a particular day during a month is linearly interpolated from the **Reference CPI** for the beginning of that month and the **Reference CPI** for the beginning of the subsequent month.
  
"""

# ╔═╡ cede4ea6-679c-416a-a9e6-dd12f0870c6a
vspace

# ╔═╡ 4366610a-dbff-4a04-9233-e771ee3c49e1
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 22</div>
"""

# ╔═╡ 5f7de294-7292-4bc5-9ef6-a18b177498dc
md"""
- _Example 1_: the **Reference CPI** for _April 1_ is the CPI-U index for the month of _January_ (which is reported by the BLS during February).
- _Example 2_: the **Reference CPI** for _April 15_ is roughly the average of the CPI-U index for the month of _January_ and the CPI-U index for the month of February.
"""

# ╔═╡ c2c7dd88-4a5d-4eef-b1d0-8ae0dc24e81b
vspace

# ╔═╡ 9a741428-4c4f-4919-b1b0-5ad8c57cd0ba
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 23</div>
"""

# ╔═╡ 2b18e585-71de-4820-8a4a-d46af365789f
md"""
## Reference CPI Calculation
"""

# ╔═╡ 437de46e-78cd-4b83-9372-6a454c95d135
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/IndexationLag_Chart.svg",:width => 900)

# ╔═╡ f617fe6f-be1c-48dd-a1e0-065d476cfcf8
vspace

# ╔═╡ 8571c75c-41cc-4d93-ae71-1fa4dc621c84
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 24</div>
"""

# ╔═╡ 8c4b9294-568c-49bf-a760-c54da18de10d
md"""
## Example: Reference CPI for January 7, 1997
- To find the **Reference CPI** for any date in Janurary 1997, we first find the **Reference CPI** index levels for January 1, 1997 and for February 1, 1997.
  - The **Reference CPI** for January 1st is the CPI-U from October 1996 (published by the BLS in November).
  - The **Reference CPI** for for February 1st is the CPI-U from November 1996 (published by the BLS in December).
"""

# ╔═╡ c95f15b3-db7f-4113-a6fb-c0a202b0d601
vspace

# ╔═╡ 3ecf7eed-298e-4f0f-bb4f-d408bb6da6fd
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 25</div>
"""

# ╔═╡ 1980728f-8868-4911-a390-50134b7222bd
md"""
- Then, take the difference between the two index CPI-U index levels and divide by it by the actual number of days in the month.  
- Next, multiply the result by the number of the day for which the **Reference CPI** is to be calculated and subtract 1.
  - For example, January 7 would be 6. January 25 is 24.
- Finally, add this result to the January 1st, CPI-U index level.
"""

# ╔═╡ ae72b826-72a7-4c14-8ed6-c5c27f925dd5
vspace

# ╔═╡ e1c97aa3-10dd-4ddd-b91f-6ac371eaa6d1
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 26</div>
"""

# ╔═╡ 2e76221f-cec2-443b-b1b4-cf44d93838b3
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/RefCPICalc1997.png",:width => 900)

# ╔═╡ 60b59241-c081-4da7-9a87-986d9e5931d1
vspace

# ╔═╡ 9525c845-28d3-42ff-bd4f-a892512bc056
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 27</div>
"""

# ╔═╡ 3f620c75-69c9-461a-b8ec-396079c36088
md"""
> Jan 1 level = 158.3

> Feb 1 level = 158.6 

> 158.6 - 158.3 = 0.30 

> 0.30/31 days = .0096774 _(31 days in January)_

> .0096774 $\times$ 6 = .05806 _(January 7 minus 1 = 6)_

> CPI-U for Jan 7 = 158.3 + .05806 = 158.35806. 
"""

# ╔═╡ 37a619c7-a9bc-44be-9782-d569f473a4f4
vspace

# ╔═╡ 25eee889-2690-445f-ba9c-f718075c9e47
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 28</div>
"""

# ╔═╡ beb4b354-3cd6-4a03-b161-0cb1c1845f0b
md"""
# Inflation-Adjusted Coupon Interest
"""

# ╔═╡ b6c222b6-012b-42ea-967f-fe44a88123b9
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/of698cpi_crop.svg",:width => 500)

# ╔═╡ 882a3f32-25c5-487d-b190-7d36adbf4a2f
vspace

# ╔═╡ 45272682-1233-452c-996c-2075165efa31
vspace

# ╔═╡ 4fbe276b-e902-4301-bd6e-81ef3257b9da
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 29</div>
"""

# ╔═╡ ff2e0417-8557-4fd7-b03e-0c5aae7882f3
md"""
- The Reference CPI is then turned into a ratio to calculate the inflation adjustment for any day during the month by taking the Reference CPI on that date and dividing it by the Reference CPI at the issue date of the TIPS. 
- For example, CPI-U for Jan 15, the official issue date of the inaugural TIPS bond is 158.43548. 
- The CPI-U for Jan 25 is 158.53226.
- Hence, the inflation adjustment factor for Jan 25 is 
$I_{\text{t=1/27/1997}}=\frac{158.53226}{158.43458} = 1.00061$

"""

# ╔═╡ 28e96bec-db50-479f-8f0b-4db251fed0f1
vspace

# ╔═╡ e857746d-c9aa-42e2-a47d-280e6f5b15d1
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 30</div>
"""

# ╔═╡ 0c8d7c37-6dcd-4a8b-b333-073a4a8e99ef
md"""
# Deflation Protection
- TIPS have an embedded option that protects against deflation.
- The Treasury guarantees that the _final redemption value is no less than \$100 per \$100 nominal notional_ amount, irrespective of the movements in the CPI over the life of the bond.
- Let $F$ be the TIPS principal amount and $T$ the time to maturity of the TIPS.
- The principal cash flow at maturity $T$ is
$$F \times \max\left[\, I_T, 1 \,\right]$$
- This deflation protection does not apply to coupon cash flows.
"""

# ╔═╡ b525e280-56c3-41a8-ba28-724b593bb679
vspace

# ╔═╡ 36509b9c-a2c0-45dc-904d-50c7784de865
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 31</div>
"""

# ╔═╡ 66a72bb1-64f1-4fd9-a6df-7d922758e4c4
md"""
## Inflation-Adjusted Coupon Interest Example
"""

# ╔═╡ 9635fd8d-8ae6-424a-a1c1-803bf7c2dc78
md"""
- Let $F$ be the TIPS principal value.
- Let $c$ denote the (fixed) _real_ coupon rate on the TIPS.
- Let $T$ denote the time to maturity of the TIPS (in years).

"""

# ╔═╡ 6d047903-fa9e-47d4-9147-6518869cc074
md"""
- Principal $F$ [$]: $(@bind F Slider(100:100:1000, default=100, show_value=true))
- Real Coupon Rate c [%]: $(@bind c Slider(0:0.25:10, default=3, show_value=true))
- Time to Maturity $T$ [years]: $(@bind T Slider(1:1:30, default=5, show_value=true))
- Reference CPI at issue date: $(@bind I₀ Slider(100:1:300, default=100, show_value=true))
"""

# ╔═╡ 1c30e93c-f122-4d4a-a6a6-81e639a3f4e7
vspace

# ╔═╡ 7c2a565c-9ca8-47e3-855c-57ed3e1b2c02
vspace

# ╔═╡ 829183e1-e843-4269-ae64-211208a68f3a
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 32</div>
"""

# ╔═╡ cfa2509b-38ef-470e-8c49-481e3fdb3909
Markdown.parse("
- Suppose, \$c= $c \\%\$ and \$F=$F\$.
- In real terms, the coupon cash flows at each coupon date are 
		
\$\\frac{c}{2} \\, F = \\frac{$(c/100)}{2} \\, $F = $(c/200*F)\$
	
- Suppose there is inflation (or deflation).
- The actual cash flows (in nominal terms) of the TIPS are:
")


# ╔═╡ a7fc3f61-28a4-46c8-a7e8-4d51bc3505d9
vspace

# ╔═╡ 76c37e3b-0216-4a35-8906-a98c3ac3134a
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 33</div>
"""

# ╔═╡ ac751d3e-0dcf-4859-a7b8-6185eeff4b6b
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

# ╔═╡ acf2a75d-b5bc-4f8d-b310-6f1f95269045
vspace

# ╔═╡ 4ca2cac8-54ec-42ca-975d-b3a569816077
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 34</div>
"""

# ╔═╡ 6a4974ec-ec57-4e73-a61f-ad83958d2874
md"""
# Inflation Derivatives

- In addition to the cash inflation market, there is an active derivatives market that consists mainly of inflation swap contracts and inflation options. 
"""

# ╔═╡ 248a8abb-1de4-4e1b-8db1-39a3385fbe60
vspace

# ╔═╡ 6791518f-cf34-4680-861b-f46179b00b3f
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 35</div>
"""

# ╔═╡ aef13d6b-d776-44cd-8b91-5a3577af2338
md"""
## Inflation Swap Basics
"""

# ╔═╡ 2077ceec-2fcb-4c7e-969f-4e2ff9911e9c
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/InflSwap_Chart.svg",:width => 400)

# ╔═╡ 30e2787d-d1f3-4952-a9ce-534dd51e0f8a
vspace

# ╔═╡ 921dd4f3-8420-461d-b242-44a8d72e070a
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 36</div>
"""

# ╔═╡ e2c6fd53-4fe8-4f1f-81a1-e4008c056b3d
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/InflSwap1Yr_Des.png",:width => 900)

# ╔═╡ 67bfd8f9-5874-4205-aa6e-9851d967d939
vspace

# ╔═╡ fee8a7e7-9ae1-4af3-a3a1-5fbd950af19e
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 37</div>
"""

# ╔═╡ 14996238-3aac-4601-a529-e85e182ab028
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/InflSwap1Yr_PxQuotes.png",:width => 900)

# ╔═╡ 928af98c-90a3-4bce-826d-ff7e96d9c3a8
vspace

# ╔═╡ 55d2794b-6a93-4d81-ab15-8b39a8914ac1
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 38</div>
"""

# ╔═╡ e5a9bd4f-cbe9-44ad-bc29-55d767867fe1
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/InflSwap1Yr_Graph.png",:width => 900)

# ╔═╡ 235a2afc-1c1c-4646-a77a-5be40aab7c77
vspace

# ╔═╡ e62f896a-25e0-4fc9-b29e-247d6d9cc95d
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 39</div>
"""

# ╔═╡ 2e7bd373-6edc-44a6-8a8f-b46f88277e03
md"""
## Inflation Swap Cash Flows
"""

# ╔═╡ 727e1c36-6ce2-4114-9831-e7b3981e4ce1
md"""
- The swap is executed between two counterparties at time $t=0$ and has only one cash flow that occurs at maturity in $T$ years.
"""

# ╔═╡ bc96cd4f-c600-44fb-bfae-51b3fc974b90
vspace

# ╔═╡ b7aaf72f-1f99-4b9e-ae63-ac45227b89fb
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 40</div>
"""

# ╔═╡ efd939d0-4644-4469-a7cf-d2bfd71921e9
md"""
- For example, imagine that at time $t=0$, the five-year zero-coupon inflation swap rate is 200 basis points and that the inflation swap has a notional of \$1. 
- There are no cash flows at time $t=0$ when the swap is executed. 
- At the maturity of the swap in $T=5$ years, suppose that realized inflation is $I_T$, then the counterparties to the inflation swap exchange a cash flow of 

$$\left[ (1 + 0.0200)^5 -1 \right] − \left[I_T -1 \right],$$
"""

# ╔═╡ 71fd08a2-9236-49c0-a24e-2bb63719be44
vspace

# ╔═╡ 159f2cb9-c121-4544-a64a-1364acb61329
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 41</div>
"""

# ╔═╡ 5885afab-7b6a-4c11-8536-ef0372d8d9be
md"""
- Thus, if the realized inflation rate was 1.50% per year over the five-year horizon of the swap, 

$$I_T = 1.015^5 = 1.077284$$ 

- In this case, the net cash flow per \$1 notional of the swap from the swap would be 


$$\left[ (1 + 0.0200)^5 -1\right] − \left[1.077284 -1 \right]= 0.026797$$ 
"""

# ╔═╡ a669ac97-3e16-44c5-94ea-6807c3faa907
vspace

# ╔═╡ 97701e78-9c10-4f05-9574-6810bed2b250
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 42</div>
"""

# ╔═╡ 6c9e2711-8153-4ebe-b130-c819ff266ff6
md"""
## Inflation-Swap Term Sheet
"""

# ╔═╡ e33907ec-bcc1-48c0-a09f-cd746b46d3ea
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/InflationSwap_TermSheet.svg",:width => 900)

# ╔═╡ fb7c9b3f-ada4-4b4f-8b03-6fbde5faf6cb
vspace

# ╔═╡ 35af9942-2e51-4218-99a4-1856f2975d47
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 43</div>
"""

# ╔═╡ c0563fe7-6d8d-4a2d-9e47-fe16dcfaed61
md"""
## Inflation Swap Example
"""

# ╔═╡ d3fb968d-3aa3-44e0-ba8b-13ba61cc6a5b
md"""
- Notional $N$ [$]: $(@bind Nswap Slider(100:100:1000, default=100, show_value=true))
- Inflation Swap Rate $f$ [%]: $(@bind fswap Slider(0:0.25:10, default=3, show_value=true))
- Time to Maturity $T$ [years]: $(@bind Tswap Slider(1:1:30, default=5, show_value=true))
- Annual Inflation Rate $i$ [%]: $(@bind Iswap Slider(0:0.25:10, default=2, show_value=true))
"""

# ╔═╡ 12a9256b-0e40-4614-b626-76633ab091b8
vspace

# ╔═╡ 85933a4c-e687-4a4b-ba9d-e5b48aeecfc8
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 44</div>
"""

# ╔═╡ 917d6d5e-bc3d-4f24-b51b-e86533e682ab
Markdown.parse("
- Cash flow on the fixed leg of the inflation swap:

\$N \\times \\left[ (1+f)^T - 1 \\right] = $(Nswap) \\times \\left[ (1+ $(fswap/100))^{$(Tswap)} -1 \\right]= $(roundmult(Nswap*( (1+fswap/100)^Tswap -1),1e-4))\$
	
- Cash flow on the floating leg of the swap:
	
\$N \\times \\left[ (1+i)^T - 1 \\right]]= $(Nswap) \\times \\left[ (1+$(Iswap/100))^{$(Tswap)} - 1 \\right]=$(roundmult(Nswap*((1+Iswap/100)^Tswap-1),1e-4))\$
	
- Net cash flow of inflation buyer: $(roundmult(Nswap*(1+Iswap/100)^Tswap - Nswap*(1+fswap/100)^Tswap,1e-4))
")


# ╔═╡ e55d85ab-c36d-4136-abe2-12f78c1ffdd1
vspace

# ╔═╡ 0387d3ed-2e77-4a0f-bbd7-c0b8799b1c49
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 45</div>
"""

# ╔═╡ 921402f8-a70c-4b45-b134-7fd70f0c699a
md"""
# Combining TIPS and Inflation Swap

- Suppose we invest in a TIPS with 6 months to maturity, coupon rate of 4%, and  (inflation-adjusted) principal of $100 .
- Suppose the market price of the TIPS is 100, and that the market price of a Treasury note with six months to maturity and coupon rate of 5% is 102.
"""

# ╔═╡ 034818e7-caae-495c-b159-e28549acd23a
vspace

# ╔═╡ da9d021a-5fbc-4fef-945e-b033316e5706
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 46</div>
"""

# ╔═╡ 780b61fc-903e-4483-80d6-3cd927676589
md"""
- Thus, we receive one final cash flow consisting of
  - Inflation-adjusted principal: $$100\times I_{0.5}$$  
    - For simplicity, we ignore the deflation option for now.
  - Inflation-adjusted coupon cash flow: $(c/2) \times I_{0.5} \times 100 = 0.02 \times I_{0.5} \times 100$
- The total cash flow from the TIPS is:
$$102 \times I_{0.5}$$
"""

# ╔═╡ 41d9d4e4-a4f0-425f-bb39-80a3c18d0289
vspace

# ╔═╡ d51f50ac-6605-4769-92ac-fc9136fb4f89
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 47</div>
"""

# ╔═╡ 824dc5be-d6ab-4d43-8795-745dc4e10c8e
md"""
- Next, suppose we enter into an inflation swap with notional amount of $102 as inflation seller. Let the fixed rate on the inflation swap be 0.9828%, i.e. $$f=0.009828$$.
- The net cash flow on the inflation swap is
$$102 \times [(1+f)^{0.5}-1] - 102 \times [I_{0.5}-1]$$
"""

# ╔═╡ b6f4724c-ed17-4edc-a565-6768fccde65f
vspace

# ╔═╡ df40556b-714e-46c7-a649-98c9dcd8d247
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 48</div>
"""

# ╔═╡ faaaae87-46e9-4fbd-82e0-6ac979f332ee
md"""
- The total cash flow of the TIPS and the inflation swap is:
$$102 \times I_{0.5} + \left(102 \times [(1+f)^{0.5}-1] - 102 \times [I_{0.5}-1] \right)$$

- Simplifying
$$102 \times (1+f)^{0.5} = 102 \times (1+0.9828\%)^{0.5} = 102.50$$
- This is a deterministic cash flow that does not depend on future inflation.
"""

# ╔═╡ 69b9a76e-622c-4b69-bcdc-a0aae02a93eb
vspace

# ╔═╡ 982be14a-9ad9-417e-bf62-de22c685d57f
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 49</div>
"""

# ╔═╡ 3e23d630-4e11-4a52-8748-d66b02d1bfd4
md"""
- Next, we take a short position in the Treasury note and buy the TIPS. 
- We pay $100 for the TIPS and get $102 in cash from shorting the Treasury notes.
- Our net cash flow is 102 - 100 = 2.
"""

# ╔═╡ 907e8564-7db0-429c-a6e7-56a1ed7fa6b7
md"""
- What is our obligation to pay in six months?
"""

# ╔═╡ 262590e2-745d-49ee-8c25-9e6f71a7b5bb
vspace

# ╔═╡ 7275809f-4e12-44aa-b7e1-ec9a2b33f870
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 50</div>
"""

# ╔═╡ caa6aae8-c3ab-40e2-a74b-a7241fabfc82
md"""
- First, we need to close out the short in the Treasury note and pay $102.50. Thus, we have a cash outflow of -102.50.
- Second, we have a cash flow from the long TIPS position and the inflation swap of $102.5. This is a cash inflow of 102.50.
- Our net cash flow is -102.5 + 102.5 = 0. Thus, we have zero cash flow in six months.
"""

# ╔═╡ 36b43def-2c99-47a5-99c6-5d9b75884340
vspace

# ╔═╡ 756420b3-7c8e-4c6f-9459-e4c1332bd381
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 51</div>
"""

# ╔═╡ d6441d19-d3d4-4d5e-9808-d93a258204f8
md"""
- However, we pocketed $2 upfront. 
- This is an arbitrage since we collect $2 now and have no future obligation in six months.
- This is the TIPS-Treasury arbitrage trading strategy in simplified form.
"""

# ╔═╡ 3f7b9aed-1bf0-4b30-b04f-ac57a9690d35
vspace

# ╔═╡ 464161bb-0c48-4a0b-963e-a57d34100e90
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 52</div>
"""

# ╔═╡ c24ef65a-7dde-4f06-bfd0-c15e2f769822
md"""
# Combining TIPS, STRIPS and Inflation Swap

- Suppose we invest in a TIPS with 6 months to maturity, coupon rate of 4%, and  (inflation-adjusted) principal of $100 .
- Suppose the market price of the TIPS is 100, and that the market price of a Treasury note with six months to maturity and coupon rate of 6% is 102.

"""

# ╔═╡ e014cbe2-51e1-4437-b6b1-4adc041e9e1a
vspace

# ╔═╡ d5cdbdc1-8a6a-4699-82bc-a350b67c5e12
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 53</div>
"""

# ╔═╡ cc9f23dc-eaa0-4d19-b673-d147fbb57057
md"""
- From the TIPS we receive one final cash flow consisting of
  - Inflation-adjusted principal: $$100\times I_{0.5}$$  
    - For simplicity, we ignore the deflation option for now.
  - Inflation-adjusted coupon cash flow: $(c/2) \times I_{0.5} \times 100 = 0.02 \times I_{0.5} \times 100$
- The total cash flow from the TIPS is:
$$102 \times I_{0.5}$$
"""

# ╔═╡ 2a7ce1ef-35e8-4553-85c3-15c98821bde6
vspace

# ╔═╡ 926bef37-ef3e-41a3-a91a-ff711cabc3c5
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 54</div>
"""

# ╔═╡ 361360cb-bdf4-4f99-8ccc-3fee22847dd2
md"""
- Next, suppose we enter into an inflation swap with notional amount of $102 as inflation seller. Let the fixed rate on the inflation swap be 0.9828%, i.e. $$f=0.009828$$.
- The net cash flow on the inflation swap is
$$102 \times [(1+f)^{0.5}-1] - 102 \times  [I_{0.5}-1]$$
"""

# ╔═╡ 3f716232-20c4-42fa-847d-e2bad3440e84
vspace

# ╔═╡ bf216356-68c2-4d70-83bf-03817b926083
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 55</div>
"""

# ╔═╡ 3f4cdf58-95df-407d-a5f1-d4077d4b9188
md"""
- The total cash flow of the TIPS and the inflation swap is:
$$102 \times I_{0.5} + \left(102 \times [(1+f)^{0.5}-1] - 102 \times [I_{0.5}-1] \right)$$
"""

# ╔═╡ 5fea7742-70a3-4a8e-892d-c70a953b0fcf
vspace

# ╔═╡ 0849f873-8fd7-44fd-ad03-1827e22a2304
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 56</div>
"""

# ╔═╡ 66a6a32b-9639-4591-aca1-56742edca665
md"""
- Simplifying
$$102 \times (1+f)^{0.5} = 102 \times (1+0.9828\%)^{0.5} = 102.50$$
- This is a deterministic cash flow that does not depend on future inflation.
"""

# ╔═╡ 7aa49db4-82df-4d28-81ae-7cf65fd3acc2
vspace

# ╔═╡ 2e17121d-69d1-4f3e-852a-e9614b6500bb
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 57</div>
"""

# ╔═╡ 23e7092b-6006-4ddd-97ff-454128a88e31
md"""
- Next, we take a short position in the Treasury note and buy the TIPS. 
- We pay $100 for the TIPS and get $102 in cash from shorting the Treasury notes.
- Our net cash flow is 102 - 100 = 2.

"""

# ╔═╡ 38b23f4a-cc30-4f6c-b802-5311c9b49db0
md"""
- What is our obligation to pay in six months?
"""

# ╔═╡ 1771917d-3f40-495d-ad52-50bf674ff0b6
vspace

# ╔═╡ 03d90943-f51d-4627-9b57-48f7f319636e
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 58</div>
"""

# ╔═╡ e9cef70a-fbf9-47a7-b5c0-aa6bb2ec5f6c
md"""
- First, we need to close out the short in the Treasury note and pay $103. Thus, we have a cash outflow of -103.00.
- Second, we have a cash flow from the long TIPS position and the inflation swap of $102.5. This is a cash inflow of 102.50.
- Our net cash flow is -103 + 102.5 = -0.50. 
"""

# ╔═╡ 55c40cff-0639-46b5-a8dc-9f8cb3738a6f
vspace

# ╔═╡ 95a5e0bd-5e5c-40cb-8039-b11e0c4b39c3
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 59</div>
"""

# ╔═╡ 8953ae0b-ab82-4173-bda8-9980ae1ef550
md"""
- Thus, we have non-zero cash outflow of fifty cents in six months.
- We want to have zero cash flows in six months. How can we achive this?
"""

# ╔═╡ 88bf0e46-17c9-4a61-9e82-9c113c1dbadd
vspace

# ╔═╡ b2a9fb91-f73a-4af5-8612-95be317bd2d8
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 60</div>
"""

# ╔═╡ 4e89c4d7-d4e8-4f68-ac5c-7b20d0c446e7
md"""
- Recall that there are STRIPS which are zero coupon bonds with just one cash flow at maturity.
- All we need is an inflow of fifty cents from a 6-month STRIPS.
"""

# ╔═╡ 06b01ce1-94dd-4ddd-ad17-2bdf3aa950ed
vspace

# ╔═╡ fda0a518-32b8-4c80-b3f4-26a70186aba8
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 61</div>
"""

# ╔═╡ 2423e58f-2ff0-4c80-9666-ccb45243ae19
md"""
- Suppose the price of a 6-month Treasury STRIPS is 99.50 (per 100 par value). The STRIPS will give us a cash inflow of 100 in 6 months.
- Since we need \$0.50, we buy \$0.50 par value of this STRIPS.
- This costs us 0.50/100 * 99.50 = $0.4975.
"""

# ╔═╡ e72cde3c-ad81-4242-8222-5d6bf86f22f4
vspace

# ╔═╡ e62f4392-0739-4480-ae3d-ffb5cbe26bf9
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 62</div>
"""

# ╔═╡ 81e531a9-3afb-4c05-a138-133467882086
md"""
- Thus, our cash flow today is now the cash inflow of 2 (from the long TIPS and short Treasury note) and the cash outflow of 0.4975 from the STRIPS.
- This is a net cash flow today of 2 - 0.4975 = 1.5025.
- We now have zero cash flow in six months and a positive cash flow of 1.5025 today.
- This is an arbitrage since we collect $1.5025 now and have no future obligation in six months.
"""

# ╔═╡ c2751108-1404-40b7-b9b0-4511f1223312
vspace

# ╔═╡ db7a306c-748d-4528-9d60-b4e23cd41e76
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 63</div>
"""

# ╔═╡ 201a91a8-4154-414e-86b1-ca578fa105c2
md"""
# TIPS-Treasury Mispricing on December 30, 2008
"""

# ╔═╡ 27038fd7-4dc4-4dd5-87dd-0032478d0622
md"""
- This table uses real market data on 12/30/2008 and shows the cash flows associated with 
  - the 7.625% Treasury bond with maturity date January 15, 2025, and 
  - the cash flows from the replicating strategy using the 2.375% TIPS issue with the same maturity date that replicates the cash flows of the Treasury bond. 
"""

# ╔═╡ 62ec696b-021f-4756-aff8-f62a122345ae
vspace

# ╔═╡ 1f3b8f28-40e6-4514-b89a-15325b6af77e
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 64</div>
"""

# ╔═╡ 1480c3c4-7ef1-413b-9cd2-5bbb9f61a2e2
md"""
- Note: 
  - Cash flows are in dollars per $100 notional. 
  - The $I_t$ denotes the realized percentage change in the CPI index from the inception of the strategy to the cash flow date. 
  - Date refers to the number of the semiannual period in which the corresponding cash flows are paid.
"""

# ╔═╡ f76b451e-f428-46c4-8863-c08be34cb1d8
vspace

# ╔═╡ 576fc7dc-8955-41c4-9534-32c899a4ea57
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 65</div>
"""

# ╔═╡ 14e6f7ed-2a81-4101-a1b5-af627df7c805
md"""
## Cash Flow Table
"""

# ╔═╡ c6df6e6e-1c72-4fbb-b73c-7c084bc96b69
md"""
- The table shows the actual cash flows that would result from applying the arbitrage strategy on December 30, 2008, to replicate the 7.625% coupon Treasury bond maturing on February 15, 2025. 
"""

# ╔═╡ 7c923c8c-9067-42af-b103-391c05bbeb98
Foldable("Cash Flow Table", 
md"""
| Date | Treasury  | TIPS         | Inflation Swaps        | STRIPS   | Total    |
|------|-----------|--------------|------------------------|----------|----------|
| 0    | −169.4793 | -101.2249    | 0                      | -45.6367 | -146.379 |
| 1    | 3.8125    | 1.1875 I$_1$    | 1.1856 − 1.1875 I$_{1}$     | 2.6269   | 3.8125   |
| 2    | 3.8125    | 1.1875 I$_2$    | 1.1638 − 1.1875 I$_{2}$     | 2.6487   | 3.8125   |
| 3    | 3.8125    | 1.1875 I$_3$    | 1.1480 − 1.1875 I$_{3}$     | 2.6645   | 3.8125   |
| 4    | 3.8125    | 1.1875 I$_4$    | 1.1467 − 1.1875 I$_{4}$     | 2.6658   | 3.8125   |
| 5    | 3.8125    | 1.1875 I$_5$    | 1.1307 − 1.1875 I$_{5}$     | 2.6818   | 3.8125   |
| 6    | 3.8125    | 1.1875 I$_6$    | 1.1376 − 1.1875 I$_{6}$     | 2.6749   | 3.8125   |
| 7    | 3.8125    | 1.1875 I$_7$    | 1.1566 − 1.1875 I$_{7}$     | 2.6559   | 3.8125   |
| 8    | 3.8125    | 1.1875 I$_8$    | 1.1616 − 1.1875 I$_{8}$     | 2.6509   | 3.8125   |
| 9    | 3.8125    | 1.1875 I$_9$    | 1.1630 − 1.1875 I$_{9}$     | 2.6495   | 3.8125   |
| 10   | 3.8125    | 1.1875 I$_{10}$   | 1.1773 − 1.1875 I$_{10}$    | 2.6352   | 3.8125   |
| 11   | 3.8125    | 1.1875 I$_{11}$   | 1.1967 − 1.1875 I$_{11}$    | 2.6128   | 3.8125   |
| 12   | 3.8125    | 1.1875 I$_{12}$   | 1.2095 − 1.1875 I$_{12}$    | 2.6030   | 3.8125   |
| 13   | 3.8125    | 1.1875 I$_{13}$   | 1.2248 − 1.1875 I$_{13}$    | 2.5877   | 3.8125   |
| 14   | 3.8125    | 1.1875 I$_{14}$   | 1.2466 − 1.1875 I$_{14}$    | 2.5659   | 3.8125   |
| 15   | 3.8125    | 1.1875 I$_{15}$   | 1.2683 − 1.1875 I$_{15}$    | 2.5442   | 3.8125   |
| 16   | 3.8125    | 1.1875 I$_{16}$   | 1.2866 − 1.1875 I$_{16}$    | 2.5259   | 3.8125   |
| 17   | 3.8125    | 1.1875 I$_{17}$   | 1.3058 − 1.1875 I$_{17}$    | 2.5067   | 3.8125   |
| 18   | 3.8125    | 1.1875 I$_{18}$   | 1.3304 − 1.1875 I$_{18}$    | 2.4821   | 3.8125   |
| 19   | 3.8125    | 1.1875 I$_{19}$   | 1.3556 − 1.1875 I$_{19}$    | 2.4569   | 3.8125   |
| 20   | 3.8125    | 1.1875 I$_{20}$   | 1.3792 − 1.1875 I$_{20}$    | 2.4333   | 3.8125   |
| 21   | 3.8125    | 1.1875 I$_{21}$   | 1.4009 − 1.1875 I$_{21}$    | 2.4116   | 3.8125   |
| 22   | 3.8125    | 1.1875 I$_{22}$   | 1.4225 − 1.1875 I$_{22}$    | 2.3900   | 3.8125   |
| 23   | 3.8125    | 1.1875 I$_{23}$   | 1.4427 − 1.1875 I$_{23}$    | 2.3698   | 3.8125   |
| 24   | 3.8125    | 1.1875 I$_{24}$   | 1.4635 − 1.1875 I$_{24}$    | 2.3490   | 3.8125   |
| 25   | 3.8125    | 1.1875 I$_{25}$   | 1.4806 − 1.1875 I$_{25}$    | 2.3319   | 3.8125   |
| 26   | 3.8125    | 1.1875 I$_{26}$   | 1.4979 − 1.1875 I$_{26}$    | 2.3146   | 3.8125   |
| 27   | 3.8125    | 1.1875 I$_{27}$   | 1.5126 − 1.1875 I$_{27}$    | 2.2999   | 3.8125   |
| 28   | 3.8125    | 1.1875 I$_{28}$   | 1.5277 − 1.1875 I$_{28}$    | 2.2848   | 3.8125   |
| 29   | 3.8125    | 1.1875 I$_{29}$   | 1.5407 − 1.1875 I$_{29}$    | 2.2718   | 3.8125   |
| 30   | 3.8125    | 1.1875 I$_{30}$   | 1.5548 − 1.1875 I$_{30}$    | 2.2577   | 3.8125   |
| 31   | 3.8125    | 1.1875 I$_{31}$   | 1.5676 − 1.1875 I$_{31}$    | 2.2449   | 3.8125   |
| 32   | 3.8125    | 1.1875 I$_{32}$   | 1.5823 − 1.1875 I$_{32}$    | 2.2302   | 3.8125   |
| 33   | 103.8125  | 101.1875 I$_{33}$ | 135.9861 −101.1875 I$_{33}$ | -32.1736 | 103.8125 |
""")

# ╔═╡ ed31f60a-8b09-4222-8b81-333eccb33c02
vspace

# ╔═╡ 6b6e71f5-7fe5-411a-b07f-96d2a48d2c8b
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 66</div>
"""

# ╔═╡ 004efec5-23d3-4940-abff-9024820daf65
md"""

- As shown, the price of the Treasury bond is **$169.479.** 
- To replicate the Treasury bond’s cash flows, the arbitrageur buys a 2.375% coupon TIPS issue with the same maturity date for a price of $101.225. 
- Since there are 33 semiannual coupon payment dates, 33 inflation swaps are executed with the indicated notional amounts.
- Finally, positions in Treasury STRIPS of varying small notional amounts are also taken by the arbitrageur. 
"""

# ╔═╡ fb7ad01e-1a12-4f06-a1a3-d1003cfea04a
vspace

# ╔═╡ fa26d973-0302-49cf-94b3-7929bfc93be5
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 67</div>
"""

# ╔═╡ 06b6deff-fb0a-4ed2-80ee-aee2cee7e0bf
md"""
- The net cash flows from the replicating strategy exactly match those from the Treasury bond, but at a cost of only **$146.379.**
- Thus, the cash flows from the Treasury bond can be replicated at a cost that is **\$23.10** less than that of the Treasury bond.
"""

# ╔═╡ 5968ffe1-2e7d-40c7-9d74-31abcaa372ed
vspace

# ╔═╡ fd4c867b-3653-4347-961e-4776197c695a
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 68</div>
"""

# ╔═╡ cded3cca-c9ac-4d7d-b9dd-4c5497aa955e
md"""
# Case Study
- Date: October 5, 2006
- TIPS CUSIP: 912828EA
- Treasury Note CUSIP: 912828EE
"""

# ╔═╡ c1410ea5-58f3-43c7-80f4-f4ed7a4fb937
vspace

# ╔═╡ fff0bb46-ec02-4a72-98e5-7bd05404c080
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 69</div>
"""

# ╔═╡ d4dab771-87f1-4fa2-b6a2-900a51af4586
md"""
## TIPS: 912828EA
"""

# ╔═╡ 8f3a465e-af54-4b0e-9210-87c140629f2f
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/TIPS_912828EA_Des.png",:width => 800)

# ╔═╡ d61da00e-9d8c-43e8-89c5-e70220dc761a
vspace

# ╔═╡ 220ae1e4-ef31-4bcf-a0c6-3d2914df4a9d
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 70</div>
"""

# ╔═╡ 049debc7-b1d5-4908-9b27-70344995a4c4
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/TIPS_912828EA_PxGraph.png",:width => 800)

# ╔═╡ abda6c84-f124-4d61-bb40-0517e28fbcf6
vspace

# ╔═╡ 5b5c69f9-817d-459e-a0ec-35175021ea44
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 71</div>
"""

# ╔═╡ 72721c2c-f227-469a-91d9-dbec158c2fa7
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/TIPS_912828EA_PxQuotes.png",:width => 800)

# ╔═╡ b9fc4b30-0fe8-4fba-8230-2bc59c87fa08
vspace

# ╔═╡ ce183b2d-c951-4978-ac99-6a77ad12633e
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 72</div>
"""

# ╔═╡ 312e0229-445e-42d4-8a0d-709c590c1add
md"""
## Treasury Note: 912828EA
"""

# ╔═╡ 97d9ba4b-880f-464e-bd94-7b72a86094b7
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/Treasury_912828EE_Des.png",:width => 800)

# ╔═╡ bf6e7d0a-7e33-47b1-9240-a0af661057f5
vspace

# ╔═╡ d8f15fe5-caa8-4562-b013-cd361e4df931
vspace

# ╔═╡ 969cf727-4c26-453a-9354-696f464b05a4
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 73</div>
"""

# ╔═╡ d16e82d8-faa9-444f-8db7-6f442c5e5fd4
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/Treasury_912828EE_PxQuotes.png",:width => 800)

# ╔═╡ dc265679-85cd-4ff1-a728-6353f36e3a9c
vspace

# ╔═╡ 1e818267-09d2-4fab-9dcb-952f51a3a62a
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 74</div>
"""

# ╔═╡ e36dc8d3-3b4e-46c4-9259-007f75068591
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/Treasury_912828EE_PxGraph_2.png",:width => 800)

# ╔═╡ 2a902bc3-9f51-4b99-a66b-85c56dd3b3f5
vspace

# ╔═╡ b48dd4b4-8f33-4327-b997-e631dca6aaf8
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 75</div>
"""

# ╔═╡ 4ac1725a-d9e5-4587-9b03-ae8b7379ed56
md"""
## Inflation Swap Rates
- Date:	10/5/2006	

| Tenor	  | SwapRate| Bloomberg| Ticker      | 
|-------- |---------|--------- | ---------   |
|1 Year	  |	0.01850	| USSWIT1  | CMPN CURNCY | 
|2 Years  |	0.02133	| USSWIT2  | CMPN CURNCY |
|3 Years  | 0.02313	| USSWIT3  | CMPN CURNCY |
|4 Years  |	0.02425	| USSWIT4  | CMPN CURNCY |
|5 Years  |	0.02503	| USSWIT5  | CMPN CURNCY |
|6 Years  |	0.02543	| USSWIT6  | CMPN CURNCY |
|7 Years  |	0.02580	| USSWIT7  | CMPN CURNCY |
|8 Years  |	0.02623	| USSWIT8  | CMPN CURNCY |
|9 Years  |	0.02648	| USSWIT9  | CMPN CURNCY |
|10 Years |	0.02683	| USSWIT10 | CMPN CURNCY |
|12 Years |	0.02733	| USSWIT12 | CMPN CURNCY |
|15 Years |	0.02798	| USSWIT15 | CMPN CURNCY |
|20 Years |	0.02960	| USSWIT20 | CMPN CURNCY |
|25 Years |	0.03070	| USSWIT25 | CMPN CURNCY |
|30 Years |	0.03170	| USSWIT30 | CMPN CURNCY |
"""

# ╔═╡ c0a3e440-c58a-4f76-a243-483b4aa69436
vspace

# ╔═╡ a578fae8-2403-40e0-8628-fb2b23231812
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 76</div>
"""

# ╔═╡ 00c3ea64-bbe5-4d7a-a1b2-1197b1455bec
md"""
## STRIPS Prices
"""

# ╔═╡ 432dae1b-89b1-4e8a-b59a-98e00391b368
Foldable("Treasury STRIPS Prices", 
md"""
#### STRIPS Prices
- Date:	10/5/2006

| BB ID            | Maturity   | 10/5/2006 |
|------------------|------------|-----------|
| 9128333P3 Govt   | 11/30/2006 | 99.483    |
| 9128333U2   Govt | 2/28/2007  | 98.308    |
| 9128333W8 Govt   | 3/31/2007  | 97.813    |
| 9128333Y4   Govt | 4/30/2007  | 97.414    |
| 9128333Z1 Govt   | 5/31/2007  | 97.103    |
| 9128334E7   Govt | 8/31/2007  | 96.008    |
| 9128334G2 Govt   | 9/30/2007  | 95.626    |
| 912833GB0   Govt | 11/15/2007 | 94.937    |
| 9128334K3 Govt   | 11/30/2007 | 94.885    |
| 912833C57   Govt | 1/15/2008  | 94.324    |
| 9128334R8 Govt   | 1/31/2008  | 94.166    |
| 912833CT5   Govt | 2/15/2008  | 93.973    |
| 9128335C0 Govt   | 2/29/2008  | 93.877    |
| 9128335K2   Govt | 3/31/2008  | 93.265    |
| 9128335Z9 Govt   | 5/31/2008  | 92.808    |
| 912833C65   Govt | 7/15/2008  | 92.106    |
| 9128336P0 Govt   | 7/31/2008  | 91.974    |
| 912833CU2   Govt | 8/15/2008  | 91.959    |
| 9128335D8 Govt   | 8/31/2008  | 91.848    |
| 912833ZY9   Govt | 9/15/2008  | 91.626    |
| 9128335L0 Govt   | 9/30/2008  | 91.243    |
| 9128335T3   Govt | 10/31/2008 | 91.086    |
| 912833GD6 Govt   | 11/15/2008 | 90.914    |
| 9128336A3   Govt | 11/30/2008 | 90.84     |
| 912833CV0 Govt   | 2/15/2009  | 89.985    |
| 9128335E6   Govt | 2/28/2009  | 89.88     |
| 9128332B5 Govt   | 3/15/2009  | 89.773    |
| 9128335M8   Govt | 3/31/2009  | 89.713    |
| 9128335U0 Govt   | 4/30/2009  | 88.682    |
| 912833GE4   Govt | 5/15/2009  | 88.717    |
| 9128336B1 Govt   | 5/31/2009  | 88.869    |
| 9128332J8   Govt | 7/15/2009  | 87.956    |
| 9128336R6 Govt   | 7/31/2009  | 87.681    |
| 9128335F3   Govt | 8/31/2009  | 87.87     |
| 9128333K4 Govt   | 9/15/2009  | 87.666    |
| 9128335N6   Govt | 9/30/2009  | 86.913    |
| 9128335V8 Govt   | 10/31/2009 | 87.278    |
| 912833GF1   Govt | 11/15/2009 | 87.055    |
| 9128336C9 Govt   | 11/30/2009 | 86.911    |
| 9128333S7   Govt | 1/15/2010  | 86.419    |
| 912833CX6 Govt   | 2/15/2010  | 86.161    |
| 9128335G1   Govt | 2/28/2010  | 86.125    |
| 9128333V0 Govt   | 3/15/2010  | 85.948    |
| 9128335P1   Govt | 3/31/2010  | 85.789    |
| 9128336D7 Govt   | 5/31/2010  | 85.119    |
| 9128335H9   Govt | 8/31/2010  | 84.304    |
| 9128334F4 Govt   | 9/15/2010  | 84.145    |
| 9128336E5   Govt | 11/30/2010 | 83.434    |
| 9128334N7 Govt   | 1/15/2011  | 82.742    |
| 9128335J5   Govt | 2/28/2011  | 82.509    |
| 912834BA5 Govt   | 3/15/2011  | 82.311    |
| 9128336F2   Govt | 5/31/2011  | 81.984    |
| 912833DA5 Govt   | 8/15/2011  | 80.721    |
| 9128336W5   Govt | 8/31/2011  | 80.652    |
| 912834BB3 Govt   | 9/15/2011  | 80.541    |
| 9128336Z8   Govt | 11/30/2011 | 80.731    |
| 9128337G9 Govt   | 2/29/2012  | 78.767    |
| 9128337K0   Govt | 5/31/2012  | 78.302    |
| 912833Y53 Govt   | 8/31/2012  | 77.112    |
| 912833Y87   Govt | 11/30/2012 | 76.043    |
| 912833Z78 Govt   | 2/28/2013  | 75.172    |
| 912834AA6   Govt | 5/31/2013  | 74.184    |
| 912834AF5 Govt   | 8/31/2013  | 73.578    |
| 912834AJ7   Govt | 11/30/2013 | 72.472    |
| 912834AV0 Govt   | 2/28/2014  | 71.589    |
| 912834DW5   Govt | 5/31/2014  | 70.67     |
| 912834AW8 Govt   | 8/31/2014  | 69.906    |
| 912834DX3   Govt | 11/30/2014 | 69.049    |
| 912834AX6 Govt   | 2/28/2015  | 68.153    |
| 912834DY1   Govt | 5/31/2015  | 67.41     |
| 912834AY4 Govt   | 8/31/2015  | 66.51     |
| 912834DZ8   Govt | 11/30/2015 | 65.644    |
| 912834AZ1 Govt   | 2/29/2016  | 64.789    |
| 912834EA2   Govt | 5/31/2016  | 64.018    |
| 912834EQ7 Govt   | 8/31/2016  | 63.176    |
| 912834EW4   Govt | 11/30/2016 | 62.346    |
| 912834FC7 Govt   | 2/28/2017  | 61.659    |
""")

# ╔═╡ 3a32907e-a61d-443e-81e3-9623539bfe89
vspace

# ╔═╡ e433b828-1c3b-4a9e-af2d-8f3c9ed97b99
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 77</div>
"""

# ╔═╡ d1eb23f3-7142-493d-b2e6-d4f844e2bfc6
md"""
## Calculations
"""

# ╔═╡ 398086e4-4a4c-45f6-a32d-cb5d8847233c
md"""
|				             | TIPS			    | Tbond     | 
|----------------------------|------------------|-----------|
| CUSIP			             | 912828EA 		| 912828EE  |
| Maturity		             | 7/15/2015		| 8/15/2015 |  
| Issue Date	             | 7/15/2005		| 8/15/2005 |
| Coupon		             | 1.875%		    | 	4.250%  |
| First Coupon Date	         | 1/15/2006		| 2/15/2006 |
| Second Coupon Date         | 7/15/2006		| 8/15/2006 |
| Reference CPI on issue date| 194.50968		| $-$       |    
| **Price Quote**	             | 96-20		    | 97-15+    |
"""

# ╔═╡ 2cf760b3-1f69-41ff-9af6-d04b92b9a10c
vspace

# ╔═╡ 740710ad-7684-4961-b7ed-3a2eec0ed352
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 78</div>
"""

# ╔═╡ 7c15360a-9f7f-45d0-8059-0420dc46b231
md"""
### Step 1.1: Calculate Full Prices of the Treasury
"""

# ╔═╡ cf85e64a-d5c4-4d04-b6ba-04ac003f7289
Markdown.parse("
- **Treasury 912727EE**
  - Quoted Price: 97-15+ per \$100 notional.
> \$97 + \\frac{15}{32} + \\frac{1}{64} = $(97+15/32+1/64)\$
")

# ╔═╡ a5a0c420-f28f-4ec4-a9e2-092a02cec9a8
vspace

# ╔═╡ 491e3dd5-bb19-4166-801c-d65a75354e26
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 79</div>
"""

# ╔═╡ 448fa11f-4bcb-4b62-9d1b-703d9a12786b
Markdown.parse("
- Accrued Interest: 
  - Current Date: 10/05/2006
  - Last Coupon Date: 8/15/2006
  - Next Coupon Date: 2/15/2007
")

# ╔═╡ d5ebca67-32b9-461d-9d4f-3285517c3cd2
vspace

# ╔═╡ 99deeb7a-9d9f-487f-8a5e-ddc74027a15f
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 80</div>
"""

# ╔═╡ d5df1ae7-9cc5-453b-b889-cd57dcc671c4
Markdown.parse("
- Days since last coupon = 17 days in August *(daycount includes the date of the previous coupon, i.e. 16+1=17)* + 30 days in September + 4 days October *(daycount excludes the settlement date, thus 4 days)*
> \$17 + 30 + 4 = $(17+30+4)\$
")

# ╔═╡ d9aa27ee-eba3-4dee-abeb-7fce49536793
vspace

# ╔═╡ 89388134-b26b-4b6a-92cf-c41c03b63134
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 81</div>
"""

# ╔═╡ 3d5a3bc4-f290-4d68-a5d4-ecdafc967537
Markdown.parse("
- Days in the coupon period = (31-15) days in August + 30 days September + 31 days in October + 30 days in November + 31 days in December + 31 days in January + 15 days in February
> \$(31-15) + 30 + 31 + 30 + 31 + 31 + 15 = $(31-15+30+31+30+31+31+15)\$
")

# ╔═╡ afc4f565-7171-4b47-93e0-ffa66386dedf
vspace

# ╔═╡ e2c5214b-e570-4df8-8931-976723a4d111
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 82</div>
"""

# ╔═╡ 7e50530e-a0ad-4709-9e89-bc7cc8575328
Markdown.parse("
- Calculate accrued interest on October 5, 2006.
> Accrued Interest = \$\\frac{0.0425}{2} \\times 100 \\times \\frac{51}{184} = $(roundmult((31-15+30+5)/(31-15+30+31+30+31+31+15)*0.0425/2*100,1e-6))\$
")

# ╔═╡ 5d53718b-a542-47ea-a4bf-7d94320d1fde
vspace

# ╔═╡ 7f06c860-1aec-45af-9023-48c16db107b1
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 83</div>
"""

# ╔═╡ 6245fadd-8dda-4e59-b619-3b0cfe8fbafe
Markdown.parse("
- Calculate the full price of the Treasury note per \$100 notional. 
  - The full price is the quoted price plus accrued interest.
> Full Price = \$$(roundmult((31-15+30+5)/(31-15+30+31+30+31+31+15)*0.0425/2*100+(97+15/32+1/64),1e-6))\$
")

# ╔═╡ dc7de81e-1342-483e-9737-cdb76456f43f
vspace

# ╔═╡ 0faa17fb-2a6c-4505-a9c5-e24dbe86e2d4
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 84</div>
"""

# ╔═╡ 31ef4b01-b5ed-47cc-9ff1-6d92ff7bd2b4
md"""
### Step 1.2: Calculate Full Prices of the TIPS
"""

# ╔═╡ d670b261-f427-4498-a8df-fcdacdb14d3e
Markdown.parse("
- **TIPS 912828EA**
  - Quoted Price: 96-20 per \$100 notional.
> \$96 + \\frac{20}{32}=$(96+20/32)\$
")

# ╔═╡ cba8fcb7-970e-47ef-9b0f-d4396e89aa66
vspace

# ╔═╡ c8f2b550-5a26-4e93-94f5-9e06c56a95e2
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 85</div>
"""

# ╔═╡ c6ae22ec-78cd-4a00-b36d-806439f9d550
Markdown.parse("
- Accrued Interest:
  - Current Date: 10/05/2006
  - Last Coupon Date: 7/15/2006
  - Next Coupon Date: 1/15/2007
")

# ╔═╡ fde6eaee-dd08-483a-87c6-6778300c311d
vspace

# ╔═╡ 1d0b5155-409f-4820-8cd3-22e641c2b17b
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 86</div>
"""

# ╔═╡ 3936d198-5f63-4192-b33b-b1ef9941964d
Markdown.parse("
- Days since last coupon = 17 days in July *(daycount includes the date of the previous coupon, i.e. 16+1=17)* + 31 days in August + 30 days in September + 4 days October *(daycount excludes the settlement date, thus 4 days)*
> \$17 + 31 + 30 + 4 = $(17+31+30+4)\$
")

# ╔═╡ b415d609-0528-4e5f-9d43-bf8cd0e25688
vspace

# ╔═╡ f3a08816-1901-4718-8df9-acd94f3c7157
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 87</div>
"""

# ╔═╡ 2bbcaee7-34a7-4596-ad38-5c6239dd08e6
Markdown.parse("
- Days in the coupon period = (31-15) days in July + 31 days in August + 30 days September + 31 days in October + 30 days in November + 31 days in December + 15 days in January 
> \$(31-15) + 31 + 30 + 31 + 30 + 31 + 15 = $(31-15+31+30+31+30+31+15)\$
")

# ╔═╡ 89516578-5de4-47b3-8629-89b590b15b19
vspace

# ╔═╡ 7994fc00-5530-4b82-9e9c-d627948c9ce6
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 88</div>
"""

# ╔═╡ fbb7288e-806e-4fec-a9f6-cd79b66d33fd
Markdown.parse("
- Calculate accrued interest on October 5, 2006.
> Accrued Interest = \$\\frac{0.01875}{2} \\times 100 \\times \\frac{82}{184} = $(roundmult(0.01875/2*100*(82/184),1e-6))\$
")

# ╔═╡ 9cd0acc2-6e2b-42ac-9f92-1692d8b55d80
vspace

# ╔═╡ c57f682c-e170-4466-9ad3-8c0883921470
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 89</div>
"""

# ╔═╡ 60913481-91ed-4959-9b01-9fe363916045
Markdown.parse("
- Calculate the full price of the Treasury TIPS per \$100 notional. 
  - The full price is the quoted price plus accrued interest.
> Full Price = \$$(roundmult((0.01875/2*100*(82/184))+(96+20/32),1e-6))\$
")

# ╔═╡ d9f93f3a-7c53-41c5-9de0-2958bb1ab91e
vspace

# ╔═╡ 77f77152-45ac-4eab-8777-046e5a985361
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 90</div>
"""

# ╔═╡ 083a0cb1-a597-46ca-84c0-e5b7ce23b53a
md"""
### Step 2: Set-up Cash Flows of the TIPS, Inflation Swaps and STRIPS
- *Note, initially we assume that the TIPS and Treasury note have identical maturity and coupon cash flow dates. The Time column lists the coupon payment dates of the TIPS.*
- The (real) coupon cash flows of the TIPS are $\frac{0.01875}{2}\times 100=0.9375$
- The coupon cash flows of the Treasury note are are $\frac{0.0425}{2}\times 100=2.125$
 
"""

# ╔═╡ ad56ba09-a69c-40db-8caf-53efdd93719a
vspace

# ╔═╡ 82116387-8c82-4d45-8bf1-30358907deb1
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 91</div>
"""

# ╔═╡ e871ef6e-f4da-4cef-aecf-4103335ebead
md"""
- *Notation*:
  - Let $P_{STR}(t,T)$ be the time-$t$ price of Treasury STRIPS with maturity in $T$ years. In the table below, we omit the $T$ to designate the coupon cash flow dates of the TIPS. 
  - Let $x_T$ denote the notional amount of the Treasury STRIPS.
  - Let $I_t/I_0$ denote the inflation adjustment on the TIPS at time $t$.
  - Let $P_{\textrm{Swap}}(t)$ denote the cash flow on the fixed leg of the inflation swap with notional of \$1, i.e. $$P_{\textrm{Swap}}(t)=(1+f_t)^t-1$$ 
  - The floating leg of the inflation swap has a time-$t$ cash flow of $\frac{I_t}{I_0} - 1$

"""

# ╔═╡ 22a618ee-40b7-4ec9-8f4c-86a0c8b454bd
vspace

# ╔═╡ fd884a2a-c7dc-4ab0-8175-edeeb08a1aa5
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 92</div>
"""

# ╔═╡ 80176747-6460-4840-992f-394e1c1112b2
md"""
### 2.1. Start with TIPS
"""

# ╔═╡ b0b36b4c-9d44-42cf-a1c2-a97fad25b84e
md"""
| Time		| TIPS 			| 
|-----------|---------------|
| 10-05-06	| $-97.0428$	    |
| 1/15/2007 | $0.9375 \times \frac{I_t}{I_0}$ |  
|  $\vdots$ | $\vdots$      | 
| 7/15/2015 | $(0.9375+100) \times \frac{I_T}{I_0}$ | 
"""

# ╔═╡ be9c0769-8d66-40d6-ab45-e4e43cbb318c
vspace

# ╔═╡ d71016b8-e032-4a7a-b53f-a954f7568084
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 93</div>
"""

# ╔═╡ 903a6516-2919-4078-89cc-264a726e07ca
md"""
### 2.2. Add Inflation Swaps
- The notional amount of the inflation swap is equal to the real coupon cash flow of the TIPS 
  - In this example, $N=0.9375$.
"""

# ╔═╡ 14623ccd-d970-4046-8e1c-89d1652e3bcf
md"""
| Time		| TIPS 			| Inflation Swaps | 
|-----------|---------------|-----------------|
| 10-05-06	| $-97.0428$	    | 0               |
| 1/15/2007 | $0.9375 \times \frac{I_t}{I_0}$ |  $-0.9375 \times \left(\frac{I_t}{I_0}-1\right) + 0.9375 \times P_{\textrm{Swap}}(t)$  | 
| $\vdots$	| $\vdots$	    | $\vdots$        |
| 7/15/2015 | $(0.9375+100) \times \frac{I_T}{I_0}$ | $-(0.9375+100) \times \left( \frac{I_T}{I_0} -1\right) + (0.9375+100) \times P_{\textrm{Swap}}(T)$ |
"""

# ╔═╡ 1839fd0e-b880-4f4a-ba6b-f8f5570eb083
vspace

# ╔═╡ 3efd9903-f973-41b0-b2e9-8c1cec080c13
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 94</div>
"""

# ╔═╡ 932c04a6-64e3-4d73-a083-c836fbafdbb3
md"""
### 2.3. Net TIPS and Inflation Swaps Cash Flows
"""

# ╔═╡ fb2d12f6-ebd2-4be5-9506-cdaa52cfaa1e
md"""
| Time		| TIPS 	+ Inflation Swaps | 
|-----------|-------------------------|
| 10-05-06	| $-97.0428$	              |
| 1/15/2007 | $0.9375  + 0.9375 \times P_{\textrm{Swap}}(t)$  | 
| $\vdots$	| $\vdots$              |
| 7/15/2015 | $(0.9375+100) + (0.9375+100) \times P_{\textrm{Swap}}(T)$ |
"""

# ╔═╡ 9dbe437a-9fdb-4eee-b6c2-43768d3c0554
vspace

# ╔═╡ 7bcb7a03-de87-477c-8259-19f5615ff08a
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 95</div>
"""

# ╔═╡ d7e38a5e-2c88-4728-b1cc-d98a5e1a6ec1
md"""
### 2.4. Add Treasury Note
"""

# ╔═╡ 4950323f-1c91-4d63-b333-410c69650352
md"""
| Time		| TIPS + Inflation Swaps | Treasury Note 	|
|-----------|------------------------|------------------|
| 10-05-06	| $-97.0428$	         | $-98.07337$      | 
| 1/15/2007 | $0.9375 \times (1+ P_{\textrm{Swap}}(t))$  | $2.125$ |
| $\vdots$	| $\vdots$             | $\vdots$	| 
| 7/15/2015 | $100.9375 \times (1+P_{\textrm{Swap}}(T))$ | $102.125$ |
"""

# ╔═╡ f3c9b76c-8215-4cb0-b3d7-98369074915e
vspace

# ╔═╡ d7a5c683-f014-478d-a705-e4c3a65a7104
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 96</div>
"""

# ╔═╡ 8d63c259-14d0-45db-bd85-93b71e963dbb
md"""
### 2.5. Add Treasury STRIPS
"""

# ╔═╡ 92383772-0e20-4302-89ca-ccb914a05a33
md"""
| Time		| TIPS + Inflation Swaps | Treasury Note 	| STRIPS 		   |
|-----------|------------------------|-----------------|-------------------|
| 10-05-06	| $-97.0428$	          | $-98.07337$          |   $-\sum_{T_i} P_{\textrm{STR}}(0,T_i)$	|
| 1/15/2007 | $0.9375 + 0.9375 \times P_{\textrm{Swap}}(t)$  | $2.125$ | $x_t \times 100$ | 
| $\vdots$  | $\vdots$               | $\vdots$        | 
| 7/15/2015 | $(0.9375+100) + (0.9375+100) \times P_{\textrm{Swap}}(T)$ | $102.125$ | $x_T \times 100$ |
"""

# ╔═╡ 232cbff2-e54d-45aa-9b82-d7089b1baeed
vspace

# ╔═╡ 16094f27-4000-427b-bd9b-50e9cf715e98
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 97</div>
"""

# ╔═╡ 03f0f3c5-cd48-4dec-b379-0d4245235f25
md"""
### 2.6. Calculate the STRIPS Positions
"""

# ╔═╡ 0e8e476f-9933-4fd0-9ad6-b01f7918a67b
md"""
- Next, we calculate the positions in Treasury STRIPS to match the cash flows from the Treasury note exactly.
"""

# ╔═╡ 7848436a-46e6-4456-8402-f34e3d16126b
vspace

# ╔═╡ 46428992-228d-4663-bbad-e015e81c339b
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 98</div>
"""

# ╔═╡ 5cc070bc-e0f6-4158-a3e2-800acac61361
md"""
- For each coupon date $t$
  - Set the notional of the Treasury STRIPS to enter into such that the total cash flow from the TIPS, inflation swap, and STRIPS matches exactly the fixed coupon cash flow of the Treasury note.
"""

# ╔═╡ 9d03e1f6-4ad5-4b99-9ab8-cc92bff5f224
vspace

# ╔═╡ 596bbf39-4799-4c15-8684-5f2ccbbc2611
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 99</div>
"""

# ╔═╡ a59495a8-a940-47b1-b240-685afbd62d23
md"""
  - To keep the notation general, let the fixed real TIPS cash flow be denoted by $c_{\textrm{TIPS}}= 0.9375$ and let the Treasury note cash flow be $c_{\textrm{Tnote}}=2.125$.
${c_{\textrm{TIPS}}} \times (1 + {P_{\textrm{Swap}}(t)}) + x_t \cdot 100 = {c_{\textrm{Tnote}}}$
$\to {x_t} = \frac{{{c_{\textrm{Tnote}}} - {c_{\textrm{TIPS}}} ( 1+ \cdot {P_{\textrm{Swap}}(t)}})}{{100}}$
$\to {x_t} = \frac{{{2.125} - ({c_{\textrm{TIPS}}} + {c_{\textrm{TIPS}}} \cdot {P_{\textrm{Swap}}(t)}})}{{100}}$
"""

# ╔═╡ db457538-d9a1-4acd-be2a-d89e71c43864
vspace

# ╔═╡ d65c604b-513f-4890-b386-63fd3c83d6aa
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 100</div>
"""

# ╔═╡ d72909ff-0908-4759-91be-ad420d7c47e3
md"""
- For the maturity date $T$
- Set the notional of the Treasury STRIPS to enter into such that the total cash flow from the TIPS, inflation swap, and STRIPS matches exactly the fixed coupon and principal cash flow of the Treasury note.
$\left( {100 + {c_{\textrm{TIPS}}}} \right) \times (1+ {P_{\textrm{Swap}}(T)}) + x \cdot 100 = 100 + {c_{\textrm{Tnote}}}$
$\to {x_T} = \frac{({100+{c_{Tnote}}) - (100+{c_{\textrm{TIPS}}}) \times (1 +{P_{\textrm{Swap}}(T)})}}{{100}}$
"""

# ╔═╡ 4f26206f-1093-4c9e-9ba6-bbccef8dfbf4
vspace

# ╔═╡ d4ca8a38-2cfc-4af8-affd-0171353b2c73
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 101</div>
"""

# ╔═╡ 5ec83302-d399-49a5-86fe-514f30d76c7b
md"""
## Using Market Data

- Use actual market data in Steps 2.3 to 2.6 above.
"""

# ╔═╡ 1a63c8e8-47ea-423c-8045-37b0481b25ac
vspace

# ╔═╡ 47ec8748-a18a-48ac-b0db-485f2ea6280a
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 102</div>
"""

# ╔═╡ 9860adbf-82c4-4961-a0e4-dd5c51037430
md"""
### 2.3. Net TIPS and Inflation Swaps Cash Flows
"""

# ╔═╡ 68cdb801-d6ca-4fe1-8510-5d66ac78e95e
begin
	cfDates2=Dates.Date.(["01/15/2007","07/15/2007","01/15/2008","07/15/2008","01/15/2009","07/15/2009","01/15/2010","07/15/2010","01/15/2011","07/15/2011","01/15/2012","07/15/2012","01/15/2013","07/15/2013","01/15/2014","07/15/2014","01/15/2015","07/15/2015"],"mm/dd/yyyy")
cfSwaps=[0.014123,0.017091,0.019628,0.020925,0.021960,0.022847,0.023544,0.024078,0.024534,0.024914,0.025180,0.025364,0.025533,0.025768,0.025953,0.026201,0.026308,0.026458]
cfTenors=[0.279500,0.775300,1.279500,1.778100,2.282200,2.778100,3.282200,3.778100,4.282200,4.778100,5.282200,5.780800,6.284900,6.780800,7.284900,7.780800,8.284900,8.780800]
df2 = DataFrame(Date=cfDates2, InflationSwapRates=cfSwaps,SwapTenors=cfTenors)
end

# ╔═╡ f4dc2755-9f58-4598-8216-e682f59f0632
vspace

# ╔═╡ 1735a8e9-f3b2-4630-9eaf-488c9658a9af
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 103</div>
"""

# ╔═╡ 9b1b0269-d975-446a-a168-3db32d0fdb95
md"""
- The column *Inflation Swap Rates* shows the inflation swap rates from the Bloomberg system on 10/5/2006.
- The column SwapTenors shows the swap tenors as a fraction of a year.
- The cash flow dates of the inflation swaps are on the coupon cash flow dates of the TIPS.
- For example, the first tenor as a fraction of a year is 0.2795.
    - (31-5) days in October + 30 days in November + 31 days in December + 15 days in January = 102. Thus, 102/365=0.2795. Similarly for the other cash flow dates.
"""

# ╔═╡ 43e04f32-6175-4a07-b128-427566259646
vspace

# ╔═╡ 2da7bb0b-0542-44fa-993f-4ef99ae9f180
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 104</div>
"""

# ╔═╡ 294dde1d-2ce0-40d6-b309-b50f93b15c70
md"""
- Note: To get inflation swap rates with tenors exactly matching the cash flow dates of the TIPS, we make two adjustments. 
- First, we need to account for seasonalities in inflation swap rates (e.g. inflation rates for certain months during the year are higher/lower than in other months). 
- Second, swap rates for short tenors (e.g. 1 month) are known because the reference CPI index values for near-term months are already known in the current month due to the 3-month indexaction lag). 
- For details, see Fleckenstein, Longstaff, and Lustig (2014).
"""

# ╔═╡ 712fd1e8-4f37-4e62-ad7b-46aba02778c4
vspace

# ╔═╡ 4c7bb348-f412-4cbe-9485-bd208042d69f
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 105</div>
"""

# ╔═╡ 59bdffc6-b6fd-45f7-98dc-aec5aab8b9a7
Markdown.parse("
### Calculate Cash Flows on the Fixed-Leg of the Inflation Swap
- We calculate the cash flows on the fixed leg of the inflation swap from the inflation swap rates.
- Recall that the fixed leg of the inflation swap has cash flows \$(1+f)^T\$ where \$f\$ is the inflation swap rate and \$T\$ is the swap tenor.
- Swap Fixed Leg = \$\\left( 1 + f(T)\\right)^{T} -1\$
  - For example, for the swap expiring on 2008-01-15, we have 
\$(1+0.019628)^{1.2795}-1 = $(roundmult((1+0.019628)^1.2795-1,1e-6))\$
")

# ╔═╡ fd34832a-79e3-4007-b857-c6e0072afedf
vspace

# ╔═╡ af63ee84-2a89-4964-b477-ec7101f77bb9
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 106</div>
"""

# ╔═╡ 4ca9e7a6-fa37-4df5-8941-4aa65af2822f
begin
	df3 = copy(df2)
	df3.SwapFixedLeg = ((1 .+ df2.InflationSwapRates).^(df2.SwapTenors) .-1)
	df3
end

# ╔═╡ a3aa8926-d97a-48b2-9363-2f13626e72ae
vspace

# ╔═╡ c2d17f6b-9d9f-414e-89d8-1ae5bcbc3325
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 107</div>
"""

# ╔═╡ 0ae821cb-0914-42ac-95a2-b8f4d99e154a
md"""
### Combine TIPS and Inflation Swap
"""

# ╔═╡ 9b5dafa0-1ea6-482f-98a8-f2b8bfb7e9f0
begin
	df4 = copy(df3)
	df4.TIPSAndInflationSwap = (0.01875/2*100).* (1 .+ df4.SwapFixedLeg)
	df4.TIPSAndInflationSwap[end] = (100 + (0.01875/2*100)) .* (1+df4.SwapFixedLeg[end])  
	df4
end

# ╔═╡ 6f1ca6a3-f3d0-41ad-b094-2f20910ec216
vspace

# ╔═╡ 0e6f3ac1-91b2-42b6-8716-4374f2efb4b9
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 108</div>
"""

# ╔═╡ 77b7030e-0cad-4d86-a70e-7896e0e45da7
md"""
### 2.4. Add Treasury Note
"""

# ╔═╡ b00301af-7ee3-4266-9878-44616cba7ecd
begin
	df5 = copy(df4)
	select!(df5,:Date,:TIPSAndInflationSwap)
	df5.TNote = 2.125*ones(length(df5.Date))
	df5.TNote[end] = df5.TNote[end]+100
	df5
end

# ╔═╡ 9cb70630-bdc0-48e1-a808-c6cb6ce4f027
vspace

# ╔═╡ 8b3e51a0-30da-4734-986e-9c500903e887
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 109</div>
"""

# ╔═╡ a89a9f56-8c94-47e0-9588-48ce9dcd97a4
md"""
### 2.5. Add Treasury STRIPS
"""

# ╔═╡ 81506749-c1b6-4dac-beeb-d551698afb34
begin
	df6 = copy(df5)
	df6.STRIPS = NaN.*ones(length(df6.Date))
	select!(df6, :Date, :TIPSAndInflationSwap, :STRIPS, :TNote)
	#df5.STRIPS = [98.6650,96.3040,94.1340,92.0890,90.1020,88.1370,86.2470,84.4300,82.6180,80.9500,78.6780,76.8630,75.0760,73.3200,71.5890,69.9060,68.1530,66.5100]
	df6
end

# ╔═╡ 12d49d8a-42ea-4a83-bc07-7f78ba528847
vspace

# ╔═╡ b9d27cd8-c50b-4ef6-804e-041d70ff6f88
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 110</div>
"""

# ╔═╡ 9c8fe1c2-b148-4ded-b5ae-d9c512479a50
md"""
### 2.6. Calculate the STRIPS Positions
"""

# ╔═╡ 932d7811-ebb5-4807-8270-afc8905e7b58
begin
	df6.STRIPS = df6.TNote .- df6.TIPSAndInflationSwap
	df6
end

# ╔═╡ e2ff69c8-77f1-4182-93f2-9e2bb97990be
vspace

# ╔═╡ 9bbddf39-6572-42a1-be91-f5680e828611
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 111</div>
"""

# ╔═╡ 3115e3a5-886e-4315-9c05-36cf9fe7692e
md"""
### 2.7. Calculate the Market Price fo the STRIPS Positions
"""

# ╔═╡ 73acdb08-b4d2-4e29-8004-1a936e72982f
md"""
- The column STRIPS shows the market prices of Treasury STRIPS from the Bloomberg system on 10/5/2006.
  - _Note: To match exactly the dates of the TIPS coupon cash flows, we interpolate market prices of the Treasury STRIPS. For details, see Fleckenstein, Longstaff, and Lustig (2014)._
"""

# ╔═╡ 89d87124-23a2-4241-ad68-73b5be83106b
begin
	df7 = copy(df6)
	select!(df7,:Date,)
	df7.STRIPS = [98.6650,96.3040,94.1340,92.0890,90.1020,88.1370,86.2470,84.4300,82.6180,80.9500,78.6780,76.8630,75.0760,73.3200,71.5890,69.9060,68.1530,66.5100]
	df7
end

# ╔═╡ 803017a7-afa2-439a-96c5-ff42b49e25a3
vspace

# ╔═╡ 0b8d72d5-f7d1-4d8e-81ef-137e12db567f
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 112</div>
"""

# ╔═╡ 2c8ba6e2-83a9-4c4d-98a5-a1325fba7736
begin
	df8 = copy(df6)
	df8.STRIPSPrices = df8.STRIPS .* df7.STRIPS./100
	select!(df8,:Date, :STRIPS, :STRIPSPrices)
	PxSTRIPS = sum(df8.STRIPSPrices)
	df8
end

# ╔═╡ 138a92e6-98bc-49d9-8ac1-2d75f41daaeb
Markdown.parse("
- The total price of entering the STRIPS positions is $(roundmult(PxSTRIPS,1e-6)).
")

# ╔═╡ 29568bae-ed4f-4486-9c1f-6dbb234b5842
vspace

# ╔═╡ 393a4ca5-5851-4968-abdb-443feb25194d
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 113</div>
"""

# ╔═╡ 26534a5e-a19b-4ef3-b4b3-1ab10700c601
md"""
- Is there an arbitrage?
- The TIPS has a market price of $97.0428. 
- A long position in the TIPS, inflation swaps and STRIPS costs \$97.0428 - \$1.1887 
$P_{\text{TIPS+Swap}} = $95.8541$

"""

# ╔═╡ d95020e1-680f-44e5-9049-05202d247399
vspace

# ╔═╡ 8165fec9-cdd3-4db9-9c3b-c3dbe89456d6
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 114</div>
"""

# ╔═╡ c998015a-5254-48f3-b6f7-630c2e098656
md"""
- The Treasury note has a market price of 
$P_{\text{Treasury}}= $98.0734$

- This is a puzzle because the price of two securities with exactly the same cash flows are different. 
- The Treasury note is __\$2.22__ more expensive than its equivalent TIPS.
- Thus, by buying the TIPS and entering into the inflation swaps and STRIPS and by taking a short we have an arbitrage.
"""

# ╔═╡ dc4c54ff-d99b-43d8-93b9-ed26334917e7
vspace

# ╔═╡ 568c2bcb-fa2e-4874-a3d9-243a3649b7c8
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 115</div>
"""

# ╔═╡ 569d7b82-ee46-42e2-b24e-e22272769452
md"""
## Details
- Note that the TIPS and the Treasury have slightly different maturity dates.
  - The TIPS has maturity date on July 15, 2015.
  - The Treasury note has maturity date on August 15, 2015.
- To adjust for this small difference, we take the following approach.
  - Step 1: We calculate the yield to maturity of the TIPS.
  - Step 2: We calculate the price of the Treasury note by discounting the Treasury note cash flows by the yield computed in the previous step.
"""

# ╔═╡ b92d4665-551a-4824-8314-a59edc73fbad
vspace

# ╔═╡ 8a8929a1-c6c8-4b9c-b60a-4791d9537a54
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 116</div>
"""

# ╔═╡ c87e3c57-f976-44b0-af02-c2f188a35db9
md"""
- The price calculated in step 2 is the price of the TIPS that can be compared to the price of the Treasury note because it accounts for the difference in th timing of cash flows.
- The yield of the TIPS turns out to be 4.97% and the market price of the Treasury note if its yield is 4.97% turns out to be 95.4583.
- Thus the Treasury note is \$98.07337 - \$95.4583 = \$2.61507 more expensive than the equivalent TIPS. The arbitrage mispricing is \$2.61507.
"""

# ╔═╡ f2e53056-d926-46dc-8aca-8beb68c05218
vspace

# ╔═╡ 53c77ef1-899d-47c8-8a30-ea38380d1614
md"""
# Wrap-Up
"""

# ╔═╡ 670e45a3-9d28-47ae-a6b6-a1b1c67a0a4c
begin
	html"""
	<fieldset>      
        <legend>Goals for today</legend>      
		<br>
<input type="checkbox" value="" checked=true>Be familiar with Treasury TIPS and understand how TIPS are adjusted for inflation.<br><br>
<input type="checkbox" value="" checked=true>Calculate the inflation-adjusted principal and coupon interest on Treasury TIPS.<br><br>
<input type="checkbox" value="" checked=true>Understand what inflation swaps are and how they work.<br><br>
<input type="checkbox" value="" checked=true>Be able to implement a relative-value trading strategy using Treasury TIPS and Treasury notes/bonds.<br><br>
</fieldset>      
	"""
end

# ╔═╡ f8998179-a255-4b28-94fb-25a69a51d374
vspace

# ╔═╡ 2ee2c328-5ebe-488e-94a9-2fce2200484c
md"""
# Reading
Fleckenstein, Matthias, Francis A. Longstaff, and Hanno Lustig, 2014, The TIPS–Treasury Bond Puzzle, Journal of Finance, Volume 69, Issue 5, 2014, 2151–2197.

[Link](https://doi.org/10.1111/jofi.12032)
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
Luxor = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PrettyTables = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"
ShortCodes = "f62ebe17-55c5-4640-972f-b59c0dd11ccf"

[compat]
CSV = "~0.10.9"
DataFrames = "~1.5.0"
HTTP = "~1.7.4"
HypertextLiteral = "~0.9.4"
LaTeXStrings = "~1.3.0"
Luxor = "~3.7.0"
Plots = "~1.38.10"
PlutoUI = "~0.7.50"
PrettyTables = "~2.2.3"
ShortCodes = "~0.3.5"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0"
manifest_format = "2.0"
project_hash = "bdf9949e3225dc3d9b1f2c9fdf48f787c0997bec"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "44dbf560808d49041989b8a96cae4cffbeb7966a"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.11"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "d0b3f8b4ad16cb0a2988c6788646a5e6a17b6b1b"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.0.5"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "9c209fb7536406834aa938fb149964b985de6c83"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.1"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "be6ab11021cd29f0344d5c4357b163af05a48cba"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.21.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "7a60c856b9fa189eb34f5f8a6f6b5529b7942957"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.6.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "738fec4d684a9a6ee9598a8bfee305b26831f28c"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.2"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SnoopPrecompile", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "aa51303df86f8626a962fccb878430cdb0a97eee"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.5.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "299dc33549f68299137e51e6d49a13b5b1da9673"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.1"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "e27c4ebe80e8699540f2d6c805cc12203b614f12"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.20"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "8b8a2fd4536ece6e554168c21860b6820a8a83db"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.7"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "19fad9cd9ae44847fe842558a744748084a722d1"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.7+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "37e4657cd56b11abe3d10cd4a1ec5fbdb4180263"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.7.4"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JSON3]]
deps = ["Dates", "Mmap", "Parsers", "PrecompileTools", "StructTypes", "UUIDs"]
git-tree-sha1 = "5b62d93f2582b09e469b3099d839c2d2ebf5066d"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.13.1"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.Juno]]
deps = ["Base64", "Logging", "Media", "Profile"]
git-tree-sha1 = "07cb43290a840908a771552911a6274bc6c072c7"
uuid = "e5e0dc1b-0480-54bc-9374-aad01c23163d"
version = "0.8.4"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Librsvg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pango_jll", "Pkg", "gdk_pixbuf_jll"]
git-tree-sha1 = "ae0923dab7324e6bc980834f709c4cd83dd797ed"
uuid = "925c91fb-5dd6-59dd-8e8c-345e74382d89"
version = "2.54.5+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "c3ce8e7420b3a6e071e0fe4745f5d4300e37b13f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.24"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

[[deps.Luxor]]
deps = ["Base64", "Cairo", "Colors", "Dates", "FFMPEG", "FileIO", "Juno", "LaTeXStrings", "Random", "Requires", "Rsvg", "SnoopPrecompile"]
git-tree-sha1 = "909a67c53fddd216d5e986d804b26b1e3c82d66d"
uuid = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
version = "3.7.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Media]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "75a54abd10709c01f1b86b84ec225d26e840ed58"
uuid = "e89f7d12-3494-54d1-8411-f7d8b9ae1f27"
version = "0.5.0"

[[deps.Memoize]]
deps = ["MacroTools"]
git-tree-sha1 = "2b1dfcba103de714d31c033b5dacc2e4a12c7caa"
uuid = "c03570c3-d221-55d1-a50c-7939bbd78826"
version = "0.4.4"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1aa4b74f80b01c6bc2b89992b861b5f210e665b5"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.21+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "d321bf2de576bf25ec4d3e4360faca399afca282"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.0"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "84a314e3926ba9ec66ac097e3635e270986b0f10"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.50.9+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "5a6ab2f64388fd1175effdf73fe5933ef1e0bac0"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.0"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "75ca67b2c6512ad2d0c767a7cfc55e75075f8bbc"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.16"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "b478a748be27bd2f2c73a7690da219d0844db305"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.51"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "LaTeXStrings", "Markdown", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "213579618ec1f42dea7dd637a42785a608b1ea9c"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.2.4"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rsvg]]
deps = ["Cairo", "Glib_jll", "Librsvg_jll"]
git-tree-sha1 = "3d3dc66eb46568fb3a5259034bfc752a0eb0c686"
uuid = "c4c386cf-5103-5370-be45-f3a111cca3b8"
version = "1.0.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "04bdff0b09c65ff3e06a05e3eb7b120223da3d39"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.ShortCodes]]
deps = ["Base64", "CodecZlib", "HTTP", "JSON3", "Memoize", "UUIDs"]
git-tree-sha1 = "95479a28f0bb4ad37ec7c7ece7fdbfc400c643e0"
uuid = "f62ebe17-55c5-4640-972f-b59c0dd11ccf"
version = "0.3.5"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "ef28127915f4229c971eb43f3fc075dd3fe91880"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.2.0"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "45a7769a04a3cf80da1c1c7c60caf932e6f4c9f7"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.6.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "75ebe04c5bed70b91614d684259b661c9e6274a4"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.0"

[[deps.StringManipulation]]
git-tree-sha1 = "46da2434b41f41ac3594ee9816ce5541c6096123"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.0"

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "ca4bccb03acf9faaf4137a9abc1881ed1841aa70"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.10.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "1544b926975372da01227b382066ab70e574a3ec"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "ba4aa36b2d5c98d6ed1f149da916b3ba46527b2b"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.14.0"

    [deps.Unitful.extensions]
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.gdk_pixbuf_jll]]
deps = ["Artifacts", "Glib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Xorg_libX11_jll", "libpng_jll"]
git-tree-sha1 = "e9190f9fb03f9c3b15b9fb0c380b0d57a3c8ea39"
uuid = "da03df04-f53b-5353-a52f-6a8b0620ced0"
version = "2.42.8+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.7.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─41d7b190-2a14-11ec-2469-7977eac40f12
# ╟─f0545c67-5cfd-438f-a9ef-92c35ebaefa4
# ╟─bb32ad39-8aaf-468c-a5c5-24b92cc2e622
# ╟─a5de5746-3df0-45b4-a62c-3daf36f015a5
# ╟─2f1a6f95-3c0d-4732-95f0-6cfbd8e880ec
# ╟─2ba2909e-d6f8-4847-ab98-83d848fe5273
# ╟─dc087ad9-d06c-4e1b-a404-116f7c974475
# ╟─886da2d4-c1ec-4bb4-8733-e3b46c95dd36
# ╟─6334202e-2047-4e7c-beca-020768340f08
# ╟─98f202ba-7720-40fd-b618-87bd30de840c
# ╟─e6401d0b-1cfd-4e9e-b65c-66bc51405097
# ╟─410b6e69-0ebc-4e2f-9b07-48b7f112ab83
# ╟─8f8c2c95-25ef-4da0-afe1-b0a204911aeb
# ╟─313bf11c-1888-4e82-b600-38425d2afacd
# ╟─70e71241-e939-4b06-bcbe-ff7cf611df7a
# ╟─3e8baccf-799d-4694-99b0-9612bc59928f
# ╟─cf971833-a2fa-4d6b-880e-7c2a9de0ec7d
# ╟─6815d4d8-2085-4787-b16d-55ead8b0e91d
# ╟─355989df-4aab-4c82-9e43-67123e9aecee
# ╟─9185f93e-3503-4dff-8133-8afd36fe148b
# ╟─fce5cf58-d66c-4fde-b6bb-854f745d1935
# ╟─ba12da13-8d22-44c0-a507-178e7f88c19b
# ╟─8fa726b4-7064-4bd3-a2fa-54d875593009
# ╟─aa3d4c8c-2a9d-4e5a-b622-5424f341c8fb
# ╟─d74fe545-371e-4c5d-bb31-8efaf2f10ddb
# ╟─675daf21-167e-43a2-b680-a905aaaf1563
# ╟─d1e728b2-55dd-424c-8264-c5d506570dcc
# ╟─5fff35ac-b1e2-4968-9fa0-56a38c1ffe26
# ╟─298dada3-f3a7-4ac1-bdaa-55be8b359e95
# ╟─8a1d71d6-f740-469f-8ad5-8716b8390a36
# ╟─dc307a3f-c258-49cd-bb46-499da5209f41
# ╟─d6729dc9-0706-4405-9786-0da8ef96fe0a
# ╟─679a7467-6d3a-46e2-80b2-ef325ef97ea1
# ╟─1531daab-bfc7-43fb-a336-220d41663e6f
# ╟─3e5097fe-5a26-4326-bbcd-1ae95a163c02
# ╟─9e730ef8-2791-4fd7-bd07-8844cd3c2f69
# ╟─fd4f618a-71f2-4976-8515-031e79df3e5b
# ╟─448aef9e-7b85-4b8f-ba40-7490513dfd1a
# ╟─8b9ac326-884f-4d49-bb09-b01cfa0ae9d3
# ╟─23e98ea2-bb02-4940-87f3-0a745d562204
# ╟─7e316df9-3c1d-47ca-96e7-e79984fc92cf
# ╟─1f4a1481-b28f-4906-b1b3-15b192263b83
# ╟─a97e8be6-9b30-4b2b-9f35-cb27c5353266
# ╟─cb6d785c-235d-4c8a-935e-17628c13e850
# ╟─62c1c14e-7094-430a-bcff-74e298d6597e
# ╟─7dab91e9-e501-4fed-b5b1-cdc8ac6cdf6c
# ╟─ee6ab1f4-82a5-47ed-a31a-49927cd0a762
# ╟─abe6fa93-0105-43e5-9e03-92664b563b38
# ╟─da83e6fb-96b5-4741-a843-a1a58b1315ae
# ╟─2e5233cd-a187-4336-8df8-45c5c994af2e
# ╟─348219b8-8d4c-425b-8773-b42313554eef
# ╟─2ed83178-02a6-4e60-bd33-9df1a74b2f04
# ╟─c3d5177e-5dc3-43da-a419-37b6e58ac49a
# ╟─64da17e3-7b28-4ae9-ae39-de5878cb5097
# ╟─34d8c7f7-0266-49c8-aac5-ac882d3beb48
# ╟─87b62691-4e4d-4099-8650-651c92d9ef88
# ╟─4c08a00e-e4fb-4c21-8790-0fdc25b01175
# ╟─562de281-2571-4b1f-8363-fcbd02cb3204
# ╟─444ab8c9-35b4-4bc5-bb0b-dc2410f4ccac
# ╟─b8d65061-ed96-403e-9321-44adc76d6e91
# ╟─96519f0e-df82-4c03-9c34-bee6f7fd961c
# ╟─70bf8b77-680d-4b72-b912-4f44ecfe9a24
# ╟─24412bb5-edc2-4cfc-ab4e-77f6e2873012
# ╟─7a447118-1335-41a5-8f88-9f47a6637061
# ╟─f0b795bd-a6fe-4f80-8b65-f345a5aeb953
# ╟─76204388-2bca-4054-a34c-218193d2d134
# ╟─807e7022-e410-40a2-9715-4bee4d7a86aa
# ╟─dca49c6a-a897-442e-8924-7b171e806fc5
# ╟─b969b168-ec64-4a68-99bd-23b7067b0048
# ╟─9ed05f91-a314-4e6c-b05c-8d372d0f2d0f
# ╟─030fafca-4e4c-44dc-a502-325dabe79cb0
# ╟─977ba39b-5e9d-4591-a5f0-3b6fc0b5fec4
# ╟─4c81d7cf-a79d-43ee-85b6-230ba1b7c6ed
# ╟─6966dc19-0cf1-43db-a84a-7eec99d63706
# ╟─a0af3215-6ecc-4083-afaa-31c476ebae4a
# ╟─9b7aeb59-1592-4568-9152-d3e333317f95
# ╟─69d93c06-c1ac-40e9-8e34-ed0479514254
# ╟─015d265b-55a0-48a0-9878-b3e71b591931
# ╟─cede4ea6-679c-416a-a9e6-dd12f0870c6a
# ╟─4366610a-dbff-4a04-9233-e771ee3c49e1
# ╟─5f7de294-7292-4bc5-9ef6-a18b177498dc
# ╟─c2c7dd88-4a5d-4eef-b1d0-8ae0dc24e81b
# ╟─9a741428-4c4f-4919-b1b0-5ad8c57cd0ba
# ╟─2b18e585-71de-4820-8a4a-d46af365789f
# ╟─437de46e-78cd-4b83-9372-6a454c95d135
# ╟─f617fe6f-be1c-48dd-a1e0-065d476cfcf8
# ╟─8571c75c-41cc-4d93-ae71-1fa4dc621c84
# ╟─8c4b9294-568c-49bf-a760-c54da18de10d
# ╟─c95f15b3-db7f-4113-a6fb-c0a202b0d601
# ╟─3ecf7eed-298e-4f0f-bb4f-d408bb6da6fd
# ╟─1980728f-8868-4911-a390-50134b7222bd
# ╟─ae72b826-72a7-4c14-8ed6-c5c27f925dd5
# ╟─e1c97aa3-10dd-4ddd-b91f-6ac371eaa6d1
# ╟─2e76221f-cec2-443b-b1b4-cf44d93838b3
# ╟─60b59241-c081-4da7-9a87-986d9e5931d1
# ╟─9525c845-28d3-42ff-bd4f-a892512bc056
# ╟─3f620c75-69c9-461a-b8ec-396079c36088
# ╟─37a619c7-a9bc-44be-9782-d569f473a4f4
# ╟─25eee889-2690-445f-ba9c-f718075c9e47
# ╟─beb4b354-3cd6-4a03-b161-0cb1c1845f0b
# ╟─b6c222b6-012b-42ea-967f-fe44a88123b9
# ╟─882a3f32-25c5-487d-b190-7d36adbf4a2f
# ╟─45272682-1233-452c-996c-2075165efa31
# ╟─4fbe276b-e902-4301-bd6e-81ef3257b9da
# ╟─ff2e0417-8557-4fd7-b03e-0c5aae7882f3
# ╟─28e96bec-db50-479f-8f0b-4db251fed0f1
# ╟─e857746d-c9aa-42e2-a47d-280e6f5b15d1
# ╟─0c8d7c37-6dcd-4a8b-b333-073a4a8e99ef
# ╟─b525e280-56c3-41a8-ba28-724b593bb679
# ╟─36509b9c-a2c0-45dc-904d-50c7784de865
# ╟─66a72bb1-64f1-4fd9-a6df-7d922758e4c4
# ╟─9635fd8d-8ae6-424a-a1c1-803bf7c2dc78
# ╟─6d047903-fa9e-47d4-9147-6518869cc074
# ╟─1c30e93c-f122-4d4a-a6a6-81e639a3f4e7
# ╟─7c2a565c-9ca8-47e3-855c-57ed3e1b2c02
# ╟─829183e1-e843-4269-ae64-211208a68f3a
# ╟─cfa2509b-38ef-470e-8c49-481e3fdb3909
# ╟─a7fc3f61-28a4-46c8-a7e8-4d51bc3505d9
# ╟─76c37e3b-0216-4a35-8906-a98c3ac3134a
# ╟─ac751d3e-0dcf-4859-a7b8-6185eeff4b6b
# ╟─acf2a75d-b5bc-4f8d-b310-6f1f95269045
# ╟─4ca2cac8-54ec-42ca-975d-b3a569816077
# ╟─6a4974ec-ec57-4e73-a61f-ad83958d2874
# ╟─248a8abb-1de4-4e1b-8db1-39a3385fbe60
# ╟─6791518f-cf34-4680-861b-f46179b00b3f
# ╟─aef13d6b-d776-44cd-8b91-5a3577af2338
# ╟─2077ceec-2fcb-4c7e-969f-4e2ff9911e9c
# ╟─30e2787d-d1f3-4952-a9ce-534dd51e0f8a
# ╟─921dd4f3-8420-461d-b242-44a8d72e070a
# ╟─e2c6fd53-4fe8-4f1f-81a1-e4008c056b3d
# ╟─67bfd8f9-5874-4205-aa6e-9851d967d939
# ╟─fee8a7e7-9ae1-4af3-a3a1-5fbd950af19e
# ╟─14996238-3aac-4601-a529-e85e182ab028
# ╟─928af98c-90a3-4bce-826d-ff7e96d9c3a8
# ╟─55d2794b-6a93-4d81-ab15-8b39a8914ac1
# ╟─e5a9bd4f-cbe9-44ad-bc29-55d767867fe1
# ╟─235a2afc-1c1c-4646-a77a-5be40aab7c77
# ╟─e62f896a-25e0-4fc9-b29e-247d6d9cc95d
# ╟─2e7bd373-6edc-44a6-8a8f-b46f88277e03
# ╟─727e1c36-6ce2-4114-9831-e7b3981e4ce1
# ╟─bc96cd4f-c600-44fb-bfae-51b3fc974b90
# ╟─b7aaf72f-1f99-4b9e-ae63-ac45227b89fb
# ╟─efd939d0-4644-4469-a7cf-d2bfd71921e9
# ╟─71fd08a2-9236-49c0-a24e-2bb63719be44
# ╟─159f2cb9-c121-4544-a64a-1364acb61329
# ╟─5885afab-7b6a-4c11-8536-ef0372d8d9be
# ╟─a669ac97-3e16-44c5-94ea-6807c3faa907
# ╟─97701e78-9c10-4f05-9574-6810bed2b250
# ╟─6c9e2711-8153-4ebe-b130-c819ff266ff6
# ╟─e33907ec-bcc1-48c0-a09f-cd746b46d3ea
# ╟─fb7c9b3f-ada4-4b4f-8b03-6fbde5faf6cb
# ╟─35af9942-2e51-4218-99a4-1856f2975d47
# ╟─c0563fe7-6d8d-4a2d-9e47-fe16dcfaed61
# ╟─d3fb968d-3aa3-44e0-ba8b-13ba61cc6a5b
# ╟─12a9256b-0e40-4614-b626-76633ab091b8
# ╟─85933a4c-e687-4a4b-ba9d-e5b48aeecfc8
# ╟─917d6d5e-bc3d-4f24-b51b-e86533e682ab
# ╟─e55d85ab-c36d-4136-abe2-12f78c1ffdd1
# ╟─0387d3ed-2e77-4a0f-bbd7-c0b8799b1c49
# ╟─921402f8-a70c-4b45-b134-7fd70f0c699a
# ╟─034818e7-caae-495c-b159-e28549acd23a
# ╟─da9d021a-5fbc-4fef-945e-b033316e5706
# ╟─780b61fc-903e-4483-80d6-3cd927676589
# ╟─41d9d4e4-a4f0-425f-bb39-80a3c18d0289
# ╟─d51f50ac-6605-4769-92ac-fc9136fb4f89
# ╟─824dc5be-d6ab-4d43-8795-745dc4e10c8e
# ╟─b6f4724c-ed17-4edc-a565-6768fccde65f
# ╟─df40556b-714e-46c7-a649-98c9dcd8d247
# ╟─faaaae87-46e9-4fbd-82e0-6ac979f332ee
# ╟─69b9a76e-622c-4b69-bcdc-a0aae02a93eb
# ╟─982be14a-9ad9-417e-bf62-de22c685d57f
# ╟─3e23d630-4e11-4a52-8748-d66b02d1bfd4
# ╟─907e8564-7db0-429c-a6e7-56a1ed7fa6b7
# ╟─262590e2-745d-49ee-8c25-9e6f71a7b5bb
# ╟─7275809f-4e12-44aa-b7e1-ec9a2b33f870
# ╟─caa6aae8-c3ab-40e2-a74b-a7241fabfc82
# ╟─36b43def-2c99-47a5-99c6-5d9b75884340
# ╟─756420b3-7c8e-4c6f-9459-e4c1332bd381
# ╟─d6441d19-d3d4-4d5e-9808-d93a258204f8
# ╟─3f7b9aed-1bf0-4b30-b04f-ac57a9690d35
# ╟─464161bb-0c48-4a0b-963e-a57d34100e90
# ╟─c24ef65a-7dde-4f06-bfd0-c15e2f769822
# ╟─e014cbe2-51e1-4437-b6b1-4adc041e9e1a
# ╟─d5cdbdc1-8a6a-4699-82bc-a350b67c5e12
# ╟─cc9f23dc-eaa0-4d19-b673-d147fbb57057
# ╟─2a7ce1ef-35e8-4553-85c3-15c98821bde6
# ╟─926bef37-ef3e-41a3-a91a-ff711cabc3c5
# ╟─361360cb-bdf4-4f99-8ccc-3fee22847dd2
# ╟─3f716232-20c4-42fa-847d-e2bad3440e84
# ╟─bf216356-68c2-4d70-83bf-03817b926083
# ╟─3f4cdf58-95df-407d-a5f1-d4077d4b9188
# ╟─5fea7742-70a3-4a8e-892d-c70a953b0fcf
# ╟─0849f873-8fd7-44fd-ad03-1827e22a2304
# ╟─66a6a32b-9639-4591-aca1-56742edca665
# ╟─7aa49db4-82df-4d28-81ae-7cf65fd3acc2
# ╟─2e17121d-69d1-4f3e-852a-e9614b6500bb
# ╟─23e7092b-6006-4ddd-97ff-454128a88e31
# ╟─38b23f4a-cc30-4f6c-b802-5311c9b49db0
# ╟─1771917d-3f40-495d-ad52-50bf674ff0b6
# ╟─03d90943-f51d-4627-9b57-48f7f319636e
# ╟─e9cef70a-fbf9-47a7-b5c0-aa6bb2ec5f6c
# ╟─55c40cff-0639-46b5-a8dc-9f8cb3738a6f
# ╟─95a5e0bd-5e5c-40cb-8039-b11e0c4b39c3
# ╟─8953ae0b-ab82-4173-bda8-9980ae1ef550
# ╟─88bf0e46-17c9-4a61-9e82-9c113c1dbadd
# ╟─b2a9fb91-f73a-4af5-8612-95be317bd2d8
# ╟─4e89c4d7-d4e8-4f68-ac5c-7b20d0c446e7
# ╟─06b01ce1-94dd-4ddd-ad17-2bdf3aa950ed
# ╟─fda0a518-32b8-4c80-b3f4-26a70186aba8
# ╟─2423e58f-2ff0-4c80-9666-ccb45243ae19
# ╟─e72cde3c-ad81-4242-8222-5d6bf86f22f4
# ╟─e62f4392-0739-4480-ae3d-ffb5cbe26bf9
# ╟─81e531a9-3afb-4c05-a138-133467882086
# ╟─c2751108-1404-40b7-b9b0-4511f1223312
# ╟─db7a306c-748d-4528-9d60-b4e23cd41e76
# ╟─201a91a8-4154-414e-86b1-ca578fa105c2
# ╟─27038fd7-4dc4-4dd5-87dd-0032478d0622
# ╟─62ec696b-021f-4756-aff8-f62a122345ae
# ╟─1f3b8f28-40e6-4514-b89a-15325b6af77e
# ╟─1480c3c4-7ef1-413b-9cd2-5bbb9f61a2e2
# ╟─f76b451e-f428-46c4-8863-c08be34cb1d8
# ╟─576fc7dc-8955-41c4-9534-32c899a4ea57
# ╟─14e6f7ed-2a81-4101-a1b5-af627df7c805
# ╟─c6df6e6e-1c72-4fbb-b73c-7c084bc96b69
# ╟─7c923c8c-9067-42af-b103-391c05bbeb98
# ╟─ed31f60a-8b09-4222-8b81-333eccb33c02
# ╟─6b6e71f5-7fe5-411a-b07f-96d2a48d2c8b
# ╟─004efec5-23d3-4940-abff-9024820daf65
# ╟─fb7ad01e-1a12-4f06-a1a3-d1003cfea04a
# ╟─fa26d973-0302-49cf-94b3-7929bfc93be5
# ╟─06b6deff-fb0a-4ed2-80ee-aee2cee7e0bf
# ╟─5968ffe1-2e7d-40c7-9d74-31abcaa372ed
# ╟─fd4c867b-3653-4347-961e-4776197c695a
# ╟─cded3cca-c9ac-4d7d-b9dd-4c5497aa955e
# ╟─c1410ea5-58f3-43c7-80f4-f4ed7a4fb937
# ╟─fff0bb46-ec02-4a72-98e5-7bd05404c080
# ╟─d4dab771-87f1-4fa2-b6a2-900a51af4586
# ╟─8f3a465e-af54-4b0e-9210-87c140629f2f
# ╟─d61da00e-9d8c-43e8-89c5-e70220dc761a
# ╟─220ae1e4-ef31-4bcf-a0c6-3d2914df4a9d
# ╟─049debc7-b1d5-4908-9b27-70344995a4c4
# ╟─abda6c84-f124-4d61-bb40-0517e28fbcf6
# ╟─5b5c69f9-817d-459e-a0ec-35175021ea44
# ╟─72721c2c-f227-469a-91d9-dbec158c2fa7
# ╟─b9fc4b30-0fe8-4fba-8230-2bc59c87fa08
# ╟─ce183b2d-c951-4978-ac99-6a77ad12633e
# ╟─312e0229-445e-42d4-8a0d-709c590c1add
# ╟─97d9ba4b-880f-464e-bd94-7b72a86094b7
# ╟─bf6e7d0a-7e33-47b1-9240-a0af661057f5
# ╟─d8f15fe5-caa8-4562-b013-cd361e4df931
# ╟─969cf727-4c26-453a-9354-696f464b05a4
# ╟─d16e82d8-faa9-444f-8db7-6f442c5e5fd4
# ╟─dc265679-85cd-4ff1-a728-6353f36e3a9c
# ╟─1e818267-09d2-4fab-9dcb-952f51a3a62a
# ╟─e36dc8d3-3b4e-46c4-9259-007f75068591
# ╟─2a902bc3-9f51-4b99-a66b-85c56dd3b3f5
# ╟─b48dd4b4-8f33-4327-b997-e631dca6aaf8
# ╟─4ac1725a-d9e5-4587-9b03-ae8b7379ed56
# ╟─c0a3e440-c58a-4f76-a243-483b4aa69436
# ╟─a578fae8-2403-40e0-8628-fb2b23231812
# ╟─00c3ea64-bbe5-4d7a-a1b2-1197b1455bec
# ╟─432dae1b-89b1-4e8a-b59a-98e00391b368
# ╟─3a32907e-a61d-443e-81e3-9623539bfe89
# ╟─e433b828-1c3b-4a9e-af2d-8f3c9ed97b99
# ╟─d1eb23f3-7142-493d-b2e6-d4f844e2bfc6
# ╟─398086e4-4a4c-45f6-a32d-cb5d8847233c
# ╟─2cf760b3-1f69-41ff-9af6-d04b92b9a10c
# ╟─740710ad-7684-4961-b7ed-3a2eec0ed352
# ╟─7c15360a-9f7f-45d0-8059-0420dc46b231
# ╟─cf85e64a-d5c4-4d04-b6ba-04ac003f7289
# ╟─a5a0c420-f28f-4ec4-a9e2-092a02cec9a8
# ╟─491e3dd5-bb19-4166-801c-d65a75354e26
# ╟─448fa11f-4bcb-4b62-9d1b-703d9a12786b
# ╟─d5ebca67-32b9-461d-9d4f-3285517c3cd2
# ╟─99deeb7a-9d9f-487f-8a5e-ddc74027a15f
# ╟─d5df1ae7-9cc5-453b-b889-cd57dcc671c4
# ╟─d9aa27ee-eba3-4dee-abeb-7fce49536793
# ╟─89388134-b26b-4b6a-92cf-c41c03b63134
# ╟─3d5a3bc4-f290-4d68-a5d4-ecdafc967537
# ╟─afc4f565-7171-4b47-93e0-ffa66386dedf
# ╟─e2c5214b-e570-4df8-8931-976723a4d111
# ╟─7e50530e-a0ad-4709-9e89-bc7cc8575328
# ╟─5d53718b-a542-47ea-a4bf-7d94320d1fde
# ╟─7f06c860-1aec-45af-9023-48c16db107b1
# ╟─6245fadd-8dda-4e59-b619-3b0cfe8fbafe
# ╟─dc7de81e-1342-483e-9737-cdb76456f43f
# ╟─0faa17fb-2a6c-4505-a9c5-e24dbe86e2d4
# ╟─31ef4b01-b5ed-47cc-9ff1-6d92ff7bd2b4
# ╟─d670b261-f427-4498-a8df-fcdacdb14d3e
# ╟─cba8fcb7-970e-47ef-9b0f-d4396e89aa66
# ╟─c8f2b550-5a26-4e93-94f5-9e06c56a95e2
# ╟─c6ae22ec-78cd-4a00-b36d-806439f9d550
# ╟─fde6eaee-dd08-483a-87c6-6778300c311d
# ╟─1d0b5155-409f-4820-8cd3-22e641c2b17b
# ╟─3936d198-5f63-4192-b33b-b1ef9941964d
# ╟─b415d609-0528-4e5f-9d43-bf8cd0e25688
# ╟─f3a08816-1901-4718-8df9-acd94f3c7157
# ╟─2bbcaee7-34a7-4596-ad38-5c6239dd08e6
# ╟─89516578-5de4-47b3-8629-89b590b15b19
# ╟─7994fc00-5530-4b82-9e9c-d627948c9ce6
# ╟─fbb7288e-806e-4fec-a9f6-cd79b66d33fd
# ╟─9cd0acc2-6e2b-42ac-9f92-1692d8b55d80
# ╟─c57f682c-e170-4466-9ad3-8c0883921470
# ╟─60913481-91ed-4959-9b01-9fe363916045
# ╟─d9f93f3a-7c53-41c5-9de0-2958bb1ab91e
# ╟─77f77152-45ac-4eab-8777-046e5a985361
# ╟─083a0cb1-a597-46ca-84c0-e5b7ce23b53a
# ╟─ad56ba09-a69c-40db-8caf-53efdd93719a
# ╟─82116387-8c82-4d45-8bf1-30358907deb1
# ╟─e871ef6e-f4da-4cef-aecf-4103335ebead
# ╟─22a618ee-40b7-4ec9-8f4c-86a0c8b454bd
# ╟─fd884a2a-c7dc-4ab0-8175-edeeb08a1aa5
# ╟─80176747-6460-4840-992f-394e1c1112b2
# ╟─b0b36b4c-9d44-42cf-a1c2-a97fad25b84e
# ╟─be9c0769-8d66-40d6-ab45-e4e43cbb318c
# ╟─d71016b8-e032-4a7a-b53f-a954f7568084
# ╟─903a6516-2919-4078-89cc-264a726e07ca
# ╟─14623ccd-d970-4046-8e1c-89d1652e3bcf
# ╟─1839fd0e-b880-4f4a-ba6b-f8f5570eb083
# ╟─3efd9903-f973-41b0-b2e9-8c1cec080c13
# ╟─932c04a6-64e3-4d73-a083-c836fbafdbb3
# ╟─fb2d12f6-ebd2-4be5-9506-cdaa52cfaa1e
# ╟─9dbe437a-9fdb-4eee-b6c2-43768d3c0554
# ╟─7bcb7a03-de87-477c-8259-19f5615ff08a
# ╟─d7e38a5e-2c88-4728-b1cc-d98a5e1a6ec1
# ╟─4950323f-1c91-4d63-b333-410c69650352
# ╟─f3c9b76c-8215-4cb0-b3d7-98369074915e
# ╟─d7a5c683-f014-478d-a705-e4c3a65a7104
# ╟─8d63c259-14d0-45db-bd85-93b71e963dbb
# ╟─92383772-0e20-4302-89ca-ccb914a05a33
# ╟─232cbff2-e54d-45aa-9b82-d7089b1baeed
# ╟─16094f27-4000-427b-bd9b-50e9cf715e98
# ╟─03f0f3c5-cd48-4dec-b379-0d4245235f25
# ╟─0e8e476f-9933-4fd0-9ad6-b01f7918a67b
# ╟─7848436a-46e6-4456-8402-f34e3d16126b
# ╟─46428992-228d-4663-bbad-e015e81c339b
# ╟─5cc070bc-e0f6-4158-a3e2-800acac61361
# ╟─9d03e1f6-4ad5-4b99-9ab8-cc92bff5f224
# ╟─596bbf39-4799-4c15-8684-5f2ccbbc2611
# ╟─a59495a8-a940-47b1-b240-685afbd62d23
# ╟─db457538-d9a1-4acd-be2a-d89e71c43864
# ╟─d65c604b-513f-4890-b386-63fd3c83d6aa
# ╟─d72909ff-0908-4759-91be-ad420d7c47e3
# ╟─4f26206f-1093-4c9e-9ba6-bbccef8dfbf4
# ╟─d4ca8a38-2cfc-4af8-affd-0171353b2c73
# ╟─5ec83302-d399-49a5-86fe-514f30d76c7b
# ╟─1a63c8e8-47ea-423c-8045-37b0481b25ac
# ╟─47ec8748-a18a-48ac-b0db-485f2ea6280a
# ╟─9860adbf-82c4-4961-a0e4-dd5c51037430
# ╟─68cdb801-d6ca-4fe1-8510-5d66ac78e95e
# ╟─f4dc2755-9f58-4598-8216-e682f59f0632
# ╟─1735a8e9-f3b2-4630-9eaf-488c9658a9af
# ╟─9b1b0269-d975-446a-a168-3db32d0fdb95
# ╟─43e04f32-6175-4a07-b128-427566259646
# ╟─2da7bb0b-0542-44fa-993f-4ef99ae9f180
# ╟─294dde1d-2ce0-40d6-b309-b50f93b15c70
# ╟─712fd1e8-4f37-4e62-ad7b-46aba02778c4
# ╟─4c7bb348-f412-4cbe-9485-bd208042d69f
# ╟─59bdffc6-b6fd-45f7-98dc-aec5aab8b9a7
# ╟─fd34832a-79e3-4007-b857-c6e0072afedf
# ╟─af63ee84-2a89-4964-b477-ec7101f77bb9
# ╟─4ca9e7a6-fa37-4df5-8941-4aa65af2822f
# ╟─a3aa8926-d97a-48b2-9363-2f13626e72ae
# ╟─c2d17f6b-9d9f-414e-89d8-1ae5bcbc3325
# ╟─0ae821cb-0914-42ac-95a2-b8f4d99e154a
# ╟─9b5dafa0-1ea6-482f-98a8-f2b8bfb7e9f0
# ╟─6f1ca6a3-f3d0-41ad-b094-2f20910ec216
# ╟─0e6f3ac1-91b2-42b6-8716-4374f2efb4b9
# ╟─77b7030e-0cad-4d86-a70e-7896e0e45da7
# ╟─b00301af-7ee3-4266-9878-44616cba7ecd
# ╟─9cb70630-bdc0-48e1-a808-c6cb6ce4f027
# ╟─8b3e51a0-30da-4734-986e-9c500903e887
# ╟─a89a9f56-8c94-47e0-9588-48ce9dcd97a4
# ╟─81506749-c1b6-4dac-beeb-d551698afb34
# ╟─12d49d8a-42ea-4a83-bc07-7f78ba528847
# ╟─b9d27cd8-c50b-4ef6-804e-041d70ff6f88
# ╟─9c8fe1c2-b148-4ded-b5ae-d9c512479a50
# ╟─932d7811-ebb5-4807-8270-afc8905e7b58
# ╟─e2ff69c8-77f1-4182-93f2-9e2bb97990be
# ╟─9bbddf39-6572-42a1-be91-f5680e828611
# ╟─3115e3a5-886e-4315-9c05-36cf9fe7692e
# ╟─73acdb08-b4d2-4e29-8004-1a936e72982f
# ╟─89d87124-23a2-4241-ad68-73b5be83106b
# ╟─803017a7-afa2-439a-96c5-ff42b49e25a3
# ╟─0b8d72d5-f7d1-4d8e-81ef-137e12db567f
# ╟─138a92e6-98bc-49d9-8ac1-2d75f41daaeb
# ╟─2c8ba6e2-83a9-4c4d-98a5-a1325fba7736
# ╟─29568bae-ed4f-4486-9c1f-6dbb234b5842
# ╟─393a4ca5-5851-4968-abdb-443feb25194d
# ╟─26534a5e-a19b-4ef3-b4b3-1ab10700c601
# ╟─d95020e1-680f-44e5-9049-05202d247399
# ╟─8165fec9-cdd3-4db9-9c3b-c3dbe89456d6
# ╟─c998015a-5254-48f3-b6f7-630c2e098656
# ╟─dc4c54ff-d99b-43d8-93b9-ed26334917e7
# ╟─568c2bcb-fa2e-4874-a3d9-243a3649b7c8
# ╟─569d7b82-ee46-42e2-b24e-e22272769452
# ╟─b92d4665-551a-4824-8314-a59edc73fbad
# ╟─8a8929a1-c6c8-4b9c-b60a-4791d9537a54
# ╟─c87e3c57-f976-44b0-af02-c2f188a35db9
# ╟─f2e53056-d926-46dc-8aca-8beb68c05218
# ╟─53c77ef1-899d-47c8-8a30-ea38380d1614
# ╟─670e45a3-9d28-47ae-a6b6-a1b1c67a0a4c
# ╟─f8998179-a255-4b28-94fb-25a69a51d374
# ╟─2ee2c328-5ebe-488e-94a9-2fce2200484c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
