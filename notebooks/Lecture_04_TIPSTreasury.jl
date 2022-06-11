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

# ╔═╡ 4712d6fd-efb3-4f46-9160-c82797a3b5e4
# ╠═╡ show_logs = false
begin
	using Logging
	global_logger(NullLogger())
	display("")
end

# ╔═╡ f0545c67-5cfd-438f-a9ef-92c35ebaefa4
# ╠═╡ show_logs = false
#Set-up packages
begin
	
	using DataFrames, HTTP, CSV, Dates, Plots, PlutoUI, Printf, LaTeXStrings, HypertextLiteral, ShortCodes
	
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

# ╔═╡ a2959181-2de9-47b9-a4c5-2439681999ac
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
	<p align=center style="font-size:25px; font-family:family:Georgia"> <b> The TIPS-Treasury Bond Puzzle</b> <p>
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

# ╔═╡ b44fbfab-03e6-48fe-b9b0-b2c1b0d456d5
md"""
##
"""

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
		<input type="checkbox" value="">The U.S. Treasury Bond Puzzle<br><br>
		<input type="checkbox" value="">TIPS-Treasury Trading Strategy<br><br>
	</fieldset>      
	"""
end

# ╔═╡ c3363f03-fb14-4349-a2a6-5dd3b7913556
md"""
##
"""

# ╔═╡ 886da2d4-c1ec-4bb4-8733-e3b46c95dd36
md"""
# The TIPS-Treasury Bond Puzzle
"""

# ╔═╡ bd7b639c-f16a-4627-baeb-c7548f104f02
md"""
##
"""

# ╔═╡ 6334202e-2047-4e7c-beca-020768340f08
md"""
# The Largest Arbitrage Ever Documented

> - _“... you can forget about the concept of picking up pennies in front of a steamroller because ... this **arbitrage** can run to as much **$20 per $100 notional amount**.”_\
> - _“The trade was Barnegat’s most profitable and saw the fund make an impressive **132 per cent return that year**, outpacing almost every other fund in the industry.”_

Sources: [The largest arbitrage ever documented](https://www.ft.com/content/3ec205b7-4351-3c0b-a46c-e23ab86c3a44); [Hedge funds reap rewards from Treasuries](https://www.ft.com/content/a5aa3c38-c111-11df-afe0-00144feab49a)
"""

# ╔═╡ 98f202ba-7720-40fd-b618-87bd30de840c
md"""
#
"""

# ╔═╡ 410b6e69-0ebc-4e2f-9b07-48b7f112ab83
md"""
> - _**“For Barnegat the opportunity was clear: the fund bought TIPS bonds and went short on regular Treasury bonds of a matched maturity, hedging out the effect of inflation along the way with a swap contract.”**_ \
> - _“The result was a trade that would make money if the divergent prices between the two securities converged. The difference in price between the two securities narrowed sharply through 2009.”_\
> - _“ 'If 2009 was an excellent year, then 2010 is still a very good year. The opportunities are huge in some cases,' says Mr Treue. Indeed, Barnegat is up 15.75 per cent so far this year.”_

Source: [Hedge funds reap rewards from Treasuries](https://www.ft.com/content/a5aa3c38-c111-11df-afe0-00144feab49a)
"""

# ╔═╡ 8f8c2c95-25ef-4da0-afe1-b0a204911aeb
md"""
#
"""

# ╔═╡ 70e71241-e939-4b06-bcbe-ff7cf611df7a
md"""
[Presentation by Bob Treue, Fixed Income Arbitrage, Barnegat Fund Management](https://youtu.be/V-ssGaTnl8o)
"""

# ╔═╡ 3e8baccf-799d-4694-99b0-9612bc59928f
YouTube("V-ssGaTnl8o")

# ╔═╡ c986f65d-8031-490d-a0a9-e2e25a8b1310
md"""
##
"""

# ╔═╡ 355989df-4aab-4c82-9e43-67123e9aecee
md"""
# The TIPS-Treasury Bond Puzzle in the Journal of Finance
"""

# ╔═╡ 9185f93e-3503-4dff-8133-8afd36fe148b
md"""
> _"It’s contained in a great little paper published earlier this month and it isn’t a fancy, schmancy accessible to high frequency traders only type of trade."_

Source: [Kaminska (2010), FT.com](https://www.ft.com/content/3ec205b7-4351-3c0b-a46c-e23ab86c3a44)
"""

# ╔═╡ fce5cf58-d66c-4fde-b6bb-854f745d1935
md"""
#
"""

# ╔═╡ 8fa726b4-7064-4bd3-a2fa-54d875593009
# ╠═╡ show_logs = false
LocalResource("./Assets/FleckensteinLongstaffLustig2014_Abstract.svg",:width => 900)

# ╔═╡ 6c30ca52-f64e-400a-9a18-1639465c190e
md"""
##
"""

# ╔═╡ 921402f8-a70c-4b45-b134-7fd70f0c699a
md"""
# Combining TIPS and Inflation Swap

- Suppose we invest in a TIPS with 6 months to maturity, coupon rate of 4%, and  (inflation-adjusted) principal of $100 .
- Suppose the market price of the TIPS is 100, and that the market price of a Treasury note with six months to maturity and coupon rate of 5% is 102.
"""

# ╔═╡ 034818e7-caae-495c-b159-e28549acd23a
md"""
#
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
md"""
#
"""

# ╔═╡ 824dc5be-d6ab-4d43-8795-745dc4e10c8e
md"""
- Next, suppose we enter into an inflation swap with notional amount of $102 as inflation seller. Let the fixed rate on the inflation swap be 0.9828%, i.e. $$f=0.009828$$.
- The net cash flow on the inflation swap is
$$102 \times [(1+f)^{0.5}-1] - 102 \times [I_{0.5}-1]$$
"""

# ╔═╡ b6f4724c-ed17-4edc-a565-6768fccde65f
md"""
#
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
md"""
#
"""

# ╔═╡ 3e23d630-4e11-4a52-8748-d66b02d1bfd4
md"""
- Next, we take a short position in the Treasury note and buy the TIPS. 
- We pay $100 for the TIPS and get $102 in cash from shorting the Treasury notes.
- Our net cash flow is 102 - 100 = 2.
"""

# ╔═╡ 262590e2-745d-49ee-8c25-9e6f71a7b5bb
md"""
#
"""

# ╔═╡ 7275809f-4e12-44aa-b7e1-ec9a2b33f870
md"""
- What is our obligation to pay in six months?
"""

# ╔═╡ bb406003-2eb8-4e25-897e-7651fc1e719a
md"""
#
"""

# ╔═╡ caa6aae8-c3ab-40e2-a74b-a7241fabfc82
md"""
- First, we need to close out the short in the Treasury note and pay $102.50. Thus, we have a cash outflow of -102.50.
- Second, we have a cash flow from the long TIPS position and the inflation swap of $102.5. This is a cash inflow of 102.50.
- Our net cash flow is -102.5 + 102.5 = 0. Thus, we have zero cash flow in six months.
"""

# ╔═╡ 36b43def-2c99-47a5-99c6-5d9b75884340
md"""
#
"""

# ╔═╡ d6441d19-d3d4-4d5e-9808-d93a258204f8
md"""
- However, we pocketed $2 upfront. 
- This is an arbitrage since we collect $2 now and have no future obligation in six months.
- This is the TIPS-Treasury arbitrage trading strategy in simplified form.
"""

# ╔═╡ c24ef65a-7dde-4f06-bfd0-c15e2f769822
md"""
# Combining TIPS, STRIPS and Inflation Swap

- Suppose we invest in a TIPS with 6 months to maturity, coupon rate of 4%, and  (inflation-adjusted) principal of $100 .
- Suppose the market price of the TIPS is 100, and that the market price of a Treasury note with six months to maturity and coupon rate of 6% is 102.

"""

# ╔═╡ e014cbe2-51e1-4437-b6b1-4adc041e9e1a
md"""
#
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
md"""
#
"""

# ╔═╡ 361360cb-bdf4-4f99-8ccc-3fee22847dd2
md"""
- Next, suppose we enter into an inflation swap with notional amount of $102 as inflation seller. Let the fixed rate on the inflation swap be 0.9828%, i.e. $$f=0.009828$$.
- The net cash flow on the inflation swap is
$$102 \times [(1+f)^{0.5}-1] - 102 \times  [I_{0.5}-1]$$
"""

# ╔═╡ 3f716232-20c4-42fa-847d-e2bad3440e84
md"""
#
"""

# ╔═╡ 3f4cdf58-95df-407d-a5f1-d4077d4b9188
md"""
- The total cash flow of the TIPS and the inflation swap is:
$$102 \times I_{0.5} + \left(102 \times [(1+f)^{0.5}-1] - 102 \times [I_{0.5}-1] \right)$$
"""

# ╔═╡ 5fea7742-70a3-4a8e-892d-c70a953b0fcf
md"""
#
"""

# ╔═╡ 66a6a32b-9639-4591-aca1-56742edca665
md"""
- Simplifying
$$102 \times (1+f)^{0.5} = 102 \times (1+0.9828\%)^{0.5} = 102.50$$
- This is a deterministic cash flow that does not depend on future inflation.
"""

# ╔═╡ 7aa49db4-82df-4d28-81ae-7cf65fd3acc2
md"""
#
"""

# ╔═╡ 23e7092b-6006-4ddd-97ff-454128a88e31
md"""
- Next, we take a short position in the Treasury note and buy the TIPS. 
- We pay $100 for the TIPS and get $102 in cash from shorting the Treasury notes.
- Our net cash flow is 102 - 100 = 2.

"""

# ╔═╡ 1771917d-3f40-495d-ad52-50bf674ff0b6
md"""
#
"""

# ╔═╡ 76d70fe8-358f-4f2f-9a00-69a147935282
md"""
- What is our obligation to pay in six months?
"""

# ╔═╡ ff21805e-7466-4780-939b-72eeeee17e57
md"""
#
"""

# ╔═╡ e9cef70a-fbf9-47a7-b5c0-aa6bb2ec5f6c
md"""
- First, we need to close out the short in the Treasury note and pay $103. Thus, we have a cash outflow of -103.00.
- Second, we have a cash flow from the long TIPS position and the inflation swap of $102.5. This is a cash inflow of 102.50.
- Our net cash flow is -103 + 102.5 = -0.50. 
"""

# ╔═╡ 55c40cff-0639-46b5-a8dc-9f8cb3738a6f
md"""
#
"""

# ╔═╡ 8953ae0b-ab82-4173-bda8-9980ae1ef550
md"""
- Thus, we have non-zero cash outflow of fifty cents in six months.
- We want to have zero cash flows in six months. How can we achive this?
"""

# ╔═╡ 88bf0e46-17c9-4a61-9e82-9c113c1dbadd
md"""
#
"""

# ╔═╡ 4e89c4d7-d4e8-4f68-ac5c-7b20d0c446e7
md"""
- Recall that there are STRIPS which are zero coupon bonds with just one cash flow at maturity.
- All we need is an inflow of fifty cents from a 6-month STRIPS.
"""

# ╔═╡ 06b01ce1-94dd-4ddd-ad17-2bdf3aa950ed
md"""
#
"""

# ╔═╡ 2423e58f-2ff0-4c80-9666-ccb45243ae19
md"""
- Suppose the price of a 6-month Treasury STRIPS is 99.50 (per 100 par value). The STRIPS will give us a cash inflow of 100 in 6 months.
- Since we need \$0.50, we buy \$0.50 par value of this STRIPS.
- This costs us 0.50/100 * 99.50 = $0.4975.
"""

# ╔═╡ e72cde3c-ad81-4242-8222-5d6bf86f22f4
md"""
#
"""

# ╔═╡ 81e531a9-3afb-4c05-a138-133467882086
md"""
- Thus, our cash flow today is now the cash inflow of 2 (from the long TIPS and short Treasury note) and the cash outflow of 0.4975 from the STRIPS.
- This is a net cash flow today of 2 - 0.4975 = 1.5025.
- We now have zero cash flow in six months and a positive cash flow of 1.5025 today.
- This is an arbitrage since we collect $1.5025 now and have no future obligation in six months.
"""

# ╔═╡ ed5c3bc3-e514-4529-992c-ee1a4dc7ed7c
md"""
##
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
md"""
#
"""

# ╔═╡ 1480c3c4-7ef1-413b-9cd2-5bbb9f61a2e2
md"""
- Note: 
  - Cash flows are in dollars per $100 notional. 
  - The $I_t$ denotes the realized percentage change in the CPI index from the inception of the strategy to the cash flow date. 
  - Date refers to the number of the semiannual period in which the corresponding cash flows are paid.
"""

# ╔═╡ 2430b2d2-0343-4316-ae84-d7cc59759f00
md"""
##
"""

# ╔═╡ 14e6f7ed-2a81-4101-a1b5-af627df7c805
md"""
# Cash Flow Table
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
md"""
#
"""

# ╔═╡ 004efec5-23d3-4940-abff-9024820daf65
md"""

- As shown, the price of the Treasury bond is **$169.479.** 
- To replicate the Treasury bond’s cash flows, the arbitrageur buys a 2.375% coupon TIPS issue with the same maturity date for a price of $101.225. 
- Since there are 33 semiannual coupon payment dates, 33 inflation swaps are executed with the indicated notional amounts.
- Finally, positions in Treasury STRIPS of varying small notional amounts are also taken by the arbitrageur. 
"""

# ╔═╡ fb7ad01e-1a12-4f06-a1a3-d1003cfea04a
md"""
#
"""

# ╔═╡ 06b6deff-fb0a-4ed2-80ee-aee2cee7e0bf
md"""
- The net cash flows from the replicating strategy exactly match those from the Treasury bond, but at a cost of only **$146.379.**
- Thus, the cash flows from the Treasury bond can be replicated at a cost that is **\$23.10** less than that of the Treasury bond.
"""

# ╔═╡ 6edf15e1-fcad-42ed-a777-ab5be39e4a41
md"""
##
"""

# ╔═╡ cded3cca-c9ac-4d7d-b9dd-4c5497aa955e
md"""
# Case Study
- Date: October 5, 2006
- TIPS CUSIP: 912828EA
- Treasury Note CUSIP: 912828EE
"""

# ╔═╡ d4dab771-87f1-4fa2-b6a2-900a51af4586
md"""
# TIPS: 912828EA
"""

# ╔═╡ 8f3a465e-af54-4b0e-9210-87c140629f2f
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/TIPS_912828EA_Des.png",:width => 800)

# ╔═╡ d61da00e-9d8c-43e8-89c5-e70220dc761a
md"""
#
"""

# ╔═╡ 049debc7-b1d5-4908-9b27-70344995a4c4
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/TIPS_912828EA_PxGraph.png",:width => 800)

# ╔═╡ abda6c84-f124-4d61-bb40-0517e28fbcf6
md"""
#
"""

# ╔═╡ 72721c2c-f227-469a-91d9-dbec158c2fa7
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/TIPS_912828EA_PxQuotes.png",:width => 800)

# ╔═╡ 312e0229-445e-42d4-8a0d-709c590c1add
md"""
# Treasury Note: 912828EA
"""

# ╔═╡ 97d9ba4b-880f-464e-bd94-7b72a86094b7
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/Treasury_912828EE_Des.png",:width => 800)

# ╔═╡ bf6e7d0a-7e33-47b1-9240-a0af661057f5
md"""
#
"""

# ╔═╡ d16e82d8-faa9-444f-8db7-6f442c5e5fd4
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/Treasury_912828EE_PxQuotes.png",:width => 800)

# ╔═╡ dc265679-85cd-4ff1-a728-6353f36e3a9c
md"""
#
"""

# ╔═╡ e36dc8d3-3b4e-46c4-9259-007f75068591
Resource("https://raw.githubusercontent.com/fleckenstein-m/TIPS_Treas_W2022/main/notebooks/Assets/Treasury_912828EE_PxGraph_2.png",:width => 800)

# ╔═╡ 4ac1725a-d9e5-4587-9b03-ae8b7379ed56
md"""
# Inflation Swap Rates
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

# ╔═╡ 00c3ea64-bbe5-4d7a-a1b2-1197b1455bec
md"""
# STRIPS Prices
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

# ╔═╡ d1eb23f3-7142-493d-b2e6-d4f844e2bfc6
md"""
# Calculations
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

# ╔═╡ 7c15360a-9f7f-45d0-8059-0420dc46b231
md"""
# Step 1.1: Calculate Full Prices of the Treasury
"""

# ╔═╡ cf85e64a-d5c4-4d04-b6ba-04ac003f7289
Markdown.parse("
- **Treasury 912727EE**
  - Quoted Price: 97-15+ per \$100 notional.
> \$97 + \\frac{15}{32} + \\frac{1}{64} = $(97+15/32+1/64)\$
")

# ╔═╡ a5a0c420-f28f-4ec4-a9e2-092a02cec9a8
md"""
#
"""

# ╔═╡ 448fa11f-4bcb-4b62-9d1b-703d9a12786b
Markdown.parse("
- Accrued Interest: 
  - Current Date: 10/05/2006
  - Last Coupon Date: 8/15/2006
  - Next Coupon Date: 2/15/2007
")

# ╔═╡ d5ebca67-32b9-461d-9d4f-3285517c3cd2
md"""
#
"""

# ╔═╡ d5df1ae7-9cc5-453b-b889-cd57dcc671c4
Markdown.parse("
- Days since last coupon = 17 days in August *(daycount includes the date of the previous coupon, i.e. 16+1=17)* + 30 days in September + 4 days October *(daycount excludes the settlement date, thus 4 days)*
> \$17 + 30 + 4 = $(17+30+4)\$
")

# ╔═╡ d9aa27ee-eba3-4dee-abeb-7fce49536793
md"""
#
"""

# ╔═╡ 3d5a3bc4-f290-4d68-a5d4-ecdafc967537
Markdown.parse("
- Days in the coupon period = (31-15) days in August + 30 days September + 31 days in October + 30 days in November + 31 days in December + 31 days in January + 15 days in February
> \$(31-15) + 30 + 31 + 30 + 31 + 31 + 15 = $(31-15+30+31+30+31+31+15)\$
")

# ╔═╡ afc4f565-7171-4b47-93e0-ffa66386dedf
md"""
#
"""

# ╔═╡ 7e50530e-a0ad-4709-9e89-bc7cc8575328
Markdown.parse("
- Calculate accrued interest on October 5, 2006.
> Accrued Interest = \$\\frac{0.0425}{2} \\times 100 \\times \\frac{51}{184} = $(roundmult((31-15+30+5)/(31-15+30+31+30+31+31+15)*0.0425/2*100,1e-6))\$
")

# ╔═╡ 5d53718b-a542-47ea-a4bf-7d94320d1fde
md"""
#
"""

# ╔═╡ 6245fadd-8dda-4e59-b619-3b0cfe8fbafe
Markdown.parse("
- Calculate the full price of the Treasury note per \$100 notional. 
  - The full price is the quoted price plus accrued interest.
> Full Price = \$$(roundmult((31-15+30+5)/(31-15+30+31+30+31+31+15)*0.0425/2*100+(97+15/32+1/64),1e-6))\$
")

# ╔═╡ bb34c7c8-4d9a-46c8-a1e4-38e01c3c404a
md"""
##
"""

# ╔═╡ 31ef4b01-b5ed-47cc-9ff1-6d92ff7bd2b4
md"""
# Step 1.2: Calculate Full Prices of the TIPS
"""

# ╔═╡ d670b261-f427-4498-a8df-fcdacdb14d3e
Markdown.parse("
- **TIPS 912828EA**
  - Quoted Price: 96-20 per \$100 notional.
> \$96 + \\frac{20}{32}=$(96+20/32)\$
")

# ╔═╡ cba8fcb7-970e-47ef-9b0f-d4396e89aa66
md"""
#
"""

# ╔═╡ c6ae22ec-78cd-4a00-b36d-806439f9d550
Markdown.parse("
- Accrued Interest:
  - Current Date: 10/05/2006
  - Last Coupon Date: 7/15/2006
  - Next Coupon Date: 1/15/2007
")

# ╔═╡ fde6eaee-dd08-483a-87c6-6778300c311d
md"""
#
"""

# ╔═╡ 3936d198-5f63-4192-b33b-b1ef9941964d
Markdown.parse("
- Days since last coupon = 17 days in July *(daycount includes the date of the previous coupon, i.e. 16+1=17)* + 31 days in August + 30 days in September + 4 days October *(daycount excludes the settlement date, thus 4 days)*
> \$17 + 31 + 30 + 4 = $(17+31+30+4)\$
")

# ╔═╡ b415d609-0528-4e5f-9d43-bf8cd0e25688
md"""
#
"""

# ╔═╡ 2bbcaee7-34a7-4596-ad38-5c6239dd08e6
Markdown.parse("
- Days in the coupon period = (31-15) days in July + 31 days in August + 30 days September + 31 days in October + 30 days in November + 31 days in December + 15 days in January 
> \$(31-15) + 31 + 30 + 31 + 30 + 31 + 15 = $(31-15+31+30+31+30+31+15)\$
")

# ╔═╡ 89516578-5de4-47b3-8629-89b590b15b19
md"""
#
"""

# ╔═╡ fbb7288e-806e-4fec-a9f6-cd79b66d33fd
Markdown.parse("
- Calculate accrued interest on October 5, 2006.
> Accrued Interest = \$\\frac{0.01875}{2} \\times 100 \\times \\frac{82}{184} = $(roundmult(0.01875/2*100*(82/184),1e-6))\$
")

# ╔═╡ 9cd0acc2-6e2b-42ac-9f92-1692d8b55d80
md"""
#
"""

# ╔═╡ 60913481-91ed-4959-9b01-9fe363916045
Markdown.parse("
- Calculate the full price of the Treasury TIPS per \$100 notional. 
  - The full price is the quoted price plus accrued interest.
> Full Price = \$$(roundmult((0.01875/2*100*(82/184))+(96+20/32),1e-6))\$
")

# ╔═╡ 4e4f2c67-c86e-4e44-9eae-2c39f025c66d
md"""
##
"""

# ╔═╡ 083a0cb1-a597-46ca-84c0-e5b7ce23b53a
md"""
# Step 2: Set-up Cash Flows of the TIPS, Inflation Swaps and STRIPS
- *Note, initially we assume that the TIPS and Treasury note have identical maturity and coupon cash flow dates. The Time column lists the coupon payment dates of the TIPS.*
- The (real) coupon cash flows of the TIPS are $\frac{0.01875}{2}\times 100=0.9375$
- The coupon cash flows of the Treasury note are are $\frac{0.0425}{2}\times 100=2.125$
 
"""

# ╔═╡ ad56ba09-a69c-40db-8caf-53efdd93719a
md"""
#
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

# ╔═╡ 80176747-6460-4840-992f-394e1c1112b2
md"""
# 2.1. Start with TIPS
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

# ╔═╡ 903a6516-2919-4078-89cc-264a726e07ca
md"""
# 2.2. Add Inflation Swaps
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

# ╔═╡ 932c04a6-64e3-4d73-a083-c836fbafdbb3
md"""
# 2.3. Net TIPS and Inflation Swaps Cash Flows
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

# ╔═╡ d7e38a5e-2c88-4728-b1cc-d98a5e1a6ec1
md"""
# 2.4. Add Treasury Note
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

# ╔═╡ 8d63c259-14d0-45db-bd85-93b71e963dbb
md"""
# 2.5. Add Treasury STRIPS
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

# ╔═╡ 03f0f3c5-cd48-4dec-b379-0d4245235f25
md"""
# 2.6. Calculate the STRIPS Positions
"""

# ╔═╡ 0e8e476f-9933-4fd0-9ad6-b01f7918a67b
md"""
- Next, we calculate the positions in Treasury STRIPS to match the cash flows from the Treasury note exactly.
"""

# ╔═╡ 7848436a-46e6-4456-8402-f34e3d16126b
md"""
#
"""

# ╔═╡ 5cc070bc-e0f6-4158-a3e2-800acac61361
md"""
- For each coupon date $t$
  - Set the notional of the Treasury STRIPS to enter into such that the total cash flow from the TIPS, inflation swap, and STRIPS matches exactly the fixed coupon cash flow of the Treasury note.
"""

# ╔═╡ 9d03e1f6-4ad5-4b99-9ab8-cc92bff5f224
md"""
#
"""

# ╔═╡ a59495a8-a940-47b1-b240-685afbd62d23
md"""
  - To keep the notation general, let the fixed real TIPS cash flow be denoted by $c_{\textrm{TIPS}}= 0.9375$ and let the Treasury note cash flow be $c_{\textrm{Tnote}}=2.125$.
${c_{\textrm{TIPS}}} \times (1 + {P_{\textrm{Swap}}(t)}) + x_t \cdot 100 = {c_{\textrm{Tnote}}}$
$\to {x_t} = \frac{{{c_{\textrm{Tnote}}} - {c_{\textrm{TIPS}}} ( 1+ \cdot {P_{\textrm{Swap}}(t)}})}{{100}}$
$\to {x_t} = \frac{{{2.125} - ({c_{\textrm{TIPS}}} + {c_{\textrm{TIPS}}} \cdot {P_{\textrm{Swap}}(t)}})}{{100}}$
"""

# ╔═╡ db457538-d9a1-4acd-be2a-d89e71c43864
md"""
#
"""

# ╔═╡ d72909ff-0908-4759-91be-ad420d7c47e3
md"""
- For the maturity date $T$
- Set the notional of the Treasury STRIPS to enter into such that the total cash flow from the TIPS, inflation swap, and STRIPS matches exactly the fixed coupon and principal cash flow of the Treasury note.
$\left( {100 + {c_{\textrm{TIPS}}}} \right) \times (1+ {P_{\textrm{Swap}}(T)}) + x \cdot 100 = 100 + {c_{\textrm{Tnote}}}$
$\to {x_T} = \frac{({100+{c_{Tnote}}) - (100+{c_{\textrm{TIPS}}}) \times (1 +{P_{\textrm{Swap}}(T)})}}{{100}}$
"""

# ╔═╡ 5ec83302-d399-49a5-86fe-514f30d76c7b
md"""
# Using Market Data

- Use actual market data in Steps 2.3 to 2.6 above.
"""

# ╔═╡ 9860adbf-82c4-4961-a0e4-dd5c51037430
md"""
# 2.3. Net TIPS and Inflation Swaps Cash Flows
"""

# ╔═╡ 68cdb801-d6ca-4fe1-8510-5d66ac78e95e
begin
	cfDates2=Dates.Date.(["01/15/2007","07/15/2007","01/15/2008","07/15/2008","01/15/2009","07/15/2009","01/15/2010","07/15/2010","01/15/2011","07/15/2011","01/15/2012","07/15/2012","01/15/2013","07/15/2013","01/15/2014","07/15/2014","01/15/2015","07/15/2015"],"mm/dd/yyyy")
cfSwaps=[0.014123,0.017091,0.019628,0.020925,0.021960,0.022847,0.023544,0.024078,0.024534,0.024914,0.025180,0.025364,0.025533,0.025768,0.025953,0.026201,0.026308,0.026458]
cfTenors=[0.279500,0.775300,1.279500,1.778100,2.282200,2.778100,3.282200,3.778100,4.282200,4.778100,5.282200,5.780800,6.284900,6.780800,7.284900,7.780800,8.284900,8.780800]
df2 = DataFrame(Date=cfDates2, InflationSwapRates=cfSwaps,SwapTenors=cfTenors)
end

# ╔═╡ f4dc2755-9f58-4598-8216-e682f59f0632
md"""
#
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
md"""
#
"""

# ╔═╡ 294dde1d-2ce0-40d6-b309-b50f93b15c70
md"""
- Note: To get inflation swap rates with tenors exactly matching the cash flow dates of the TIPS, we make two adjustments. 
- First, we need to account for seasonalities in inflation swap rates (e.g. inflation rates for certain months during the year are higher/lower than in other months). 
- Second, swap rates for short tenors (e.g. 1 month) are known because the reference CPI index values for near-term months are already known in the current month due to the 3-month indexaction lag). 
- For details, see Fleckenstein, Longstaff, and Lustig (2014).
"""

# ╔═╡ 59bdffc6-b6fd-45f7-98dc-aec5aab8b9a7
Markdown.parse("
# Calculate Cash Flows on the Fixed-Leg of the Inflation Swap
- We calculate the cash flows on the fixed leg of the inflation swap from the inflation swap rates.
- Recall that the fixed leg of the inflation swap has cash flows \$(1+f)^T\$ where \$f\$ is the inflation swap rate and \$T\$ is the swap tenor.
- Swap Fixed Leg = \$\\left( 1 + f(T)\\right)^{T} -1\$
  - For example, for the swap expiring on 2008-01-15, we have 
\$(1+0.019628)^{1.2795}-1 = $(roundmult((1+0.019628)^1.2795-1,1e-6))\$
")

# ╔═╡ 342d06f0-bc3f-4da4-bfdc-7314fa927e9f
md"""
#
"""

# ╔═╡ 4ca9e7a6-fa37-4df5-8941-4aa65af2822f
begin
	df3 = copy(df2)
	df3.SwapFixedLeg = ((1 .+ df2.InflationSwapRates).^(df2.SwapTenors) .-1)
	df3
end

# ╔═╡ 0ae821cb-0914-42ac-95a2-b8f4d99e154a
md"""
# Combine TIPS and Inflation Swap
"""

# ╔═╡ 9b5dafa0-1ea6-482f-98a8-f2b8bfb7e9f0
begin
	df4 = copy(df3)
	df4.TIPSAndInflationSwap = (0.01875/2*100).* (1 .+ df4.SwapFixedLeg)
	df4.TIPSAndInflationSwap[end] = (100 + (0.01875/2*100)) .* (1+df4.SwapFixedLeg[end])  
	df4
end

# ╔═╡ 77b7030e-0cad-4d86-a70e-7896e0e45da7
md"""
# 2.4. Add Treasury Note
"""

# ╔═╡ b00301af-7ee3-4266-9878-44616cba7ecd
begin
	df5 = copy(df4)
	select!(df5,:Date,:TIPSAndInflationSwap)
	df5.TNote = 2.125*ones(length(df5.Date))
	df5.TNote[end] = df5.TNote[end]+100
	df5
end

# ╔═╡ a89a9f56-8c94-47e0-9588-48ce9dcd97a4
md"""
# 2.5. Add Treasury STRIPS
"""

# ╔═╡ 81506749-c1b6-4dac-beeb-d551698afb34
begin
	df6 = copy(df5)
	df6.STRIPS = NaN.*ones(length(df6.Date))
	select!(df6, :Date, :TIPSAndInflationSwap, :STRIPS, :TNote)
	#df5.STRIPS = [98.6650,96.3040,94.1340,92.0890,90.1020,88.1370,86.2470,84.4300,82.6180,80.9500,78.6780,76.8630,75.0760,73.3200,71.5890,69.9060,68.1530,66.5100]
	df6
end

# ╔═╡ 9c8fe1c2-b148-4ded-b5ae-d9c512479a50
md"""
# 2.6. Calculate the STRIPS Positions
"""

# ╔═╡ 932d7811-ebb5-4807-8270-afc8905e7b58
begin
	df6.STRIPS = df6.TNote .- df6.TIPSAndInflationSwap
	df6
end

# ╔═╡ 3115e3a5-886e-4315-9c05-36cf9fe7692e
md"""
# 2.7. Calculate the Market Price fo the STRIPS Positions
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
md"""
#
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
md"""
#
"""

# ╔═╡ 26534a5e-a19b-4ef3-b4b3-1ab10700c601
md"""
- Is there an arbitrage?
- The TIPS has a market price of $97.0428. 
- A long position in the TIPS, inflation swaps and STRIPS costs \$97.0428 - \$1.1887 
$P_{\text{TIPS+Swap}} = $95.8541$

"""

# ╔═╡ d95020e1-680f-44e5-9049-05202d247399
md"""
#
"""

# ╔═╡ c998015a-5254-48f3-b6f7-630c2e098656
md"""
- The Treasury note has a market price of 
$P_{\text{Treasury}}= $98.0734$

- This is a puzzle because the price of two securities with exactly the same cash flows are different. 
- The Treasury note is __\$2.22__ more expensive than its equivalent TIPS.
- Thus, by buying the TIPS and entering into the inflation swaps and STRIPS and by taking a short we have an arbitrage.
"""

# ╔═╡ 569d7b82-ee46-42e2-b24e-e22272769452
md"""
# Details
- Note that the TIPS and the Treasury have slightly different maturity dates.
  - The TIPS has maturity date on July 15, 2015.
  - The Treasury note has maturity date on August 15, 2015.
- To adjust for this small difference, we take the following approach.
  - Step 1: We calculate the yield to maturity of the TIPS.
  - Step 2: We calculate the price of the Treasury note by discounting the Treasury note cash flows by the yield computed in the previous step.
"""

# ╔═╡ b92d4665-551a-4824-8314-a59edc73fbad
md"""
#
"""

# ╔═╡ c87e3c57-f976-44b0-af02-c2f188a35db9
md"""
- The price calculated in step 2 is the price of the TIPS that can be compared to the price of the Treasury note because it accounts for the difference in th timing of cash flows.
- The yield of the TIPS turns out to be 4.97% and the market price of the Treasury note if its yield is 4.97% turns out to be 95.4583.
- Thus the Treasury note is \$98.07337 - \$95.4583 = \$2.61507 more expensive than the equivalent TIPS. The arbitrage mispricing is \$2.61507.
"""

# ╔═╡ 53c77ef1-899d-47c8-8a30-ea38380d1614
md"""
# Wrap-Up
"""

# ╔═╡ 670e45a3-9d28-47ae-a6b6-a1b1c67a0a4c
begin
	html"""
	<fieldset>      
        <legend>Outline</legend>      
		<br>    
		<input type="checkbox" value="" checked>The U.S. Treasury Bond Puzzle<br><br>
		<input type="checkbox" value="" checked>TIPS-Treasury Trading Strategy<br><br>
	</fieldset>      
	"""
end

# ╔═╡ 7c16c6a5-170d-4e4b-b18b-30db69eb9f6c
md"""
##
"""

# ╔═╡ 2ee2c328-5ebe-488e-94a9-2fce2200484c
md"""
# Reading: 
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
Logging = "56ddb016-857b-54e1-b83d-db4d58db5568"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"
ShortCodes = "f62ebe17-55c5-4640-972f-b59c0dd11ccf"

[compat]
CSV = "~0.9.11"
DataFrames = "~1.2.2"
HTTP = "~0.9.17"
HypertextLiteral = "~0.9.3"
LaTeXStrings = "~1.3.0"
Plots = "~1.22.4"
PlutoUI = "~0.7.15"
ShortCodes = "~0.3.2"
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
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
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

[[JSON3]]
deps = ["Dates", "Mmap", "Parsers", "StructTypes", "UUIDs"]
git-tree-sha1 = "7d58534ffb62cd947950b3aa9b993e63307a6125"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.9.2"

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
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

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

[[Memoize]]
deps = ["MacroTools"]
git-tree-sha1 = "2b1dfcba103de714d31c033b5dacc2e4a12c7caa"
uuid = "c03570c3-d221-55d1-a50c-7939bbd78826"
version = "0.4.4"

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
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

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
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

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

[[ShortCodes]]
deps = ["Base64", "CodecZlib", "HTTP", "JSON3", "Memoize", "UUIDs"]
git-tree-sha1 = "866962b3cc79ad3fee73f67408c649498bad1ac0"
uuid = "f62ebe17-55c5-4640-972f-b59c0dd11ccf"
version = "0.3.2"

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

[[StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "d24a825a95a6d98c385001212dc9020d609f2d4f"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.8.1"

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
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

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
# ╟─4712d6fd-efb3-4f46-9160-c82797a3b5e4
# ╟─41d7b190-2a14-11ec-2469-7977eac40f12
# ╟─f0545c67-5cfd-438f-a9ef-92c35ebaefa4
# ╟─a2959181-2de9-47b9-a4c5-2439681999ac
# ╟─a5de5746-3df0-45b4-a62c-3daf36f015a5
# ╟─b44fbfab-03e6-48fe-b9b0-b2c1b0d456d5
# ╟─6498b10d-bece-42bf-a32b-631224857753
# ╟─95db374b-b10d-4877-a38d-1d0ac45877c4
# ╟─c3363f03-fb14-4349-a2a6-5dd3b7913556
# ╟─886da2d4-c1ec-4bb4-8733-e3b46c95dd36
# ╟─bd7b639c-f16a-4627-baeb-c7548f104f02
# ╟─6334202e-2047-4e7c-beca-020768340f08
# ╟─98f202ba-7720-40fd-b618-87bd30de840c
# ╟─410b6e69-0ebc-4e2f-9b07-48b7f112ab83
# ╟─8f8c2c95-25ef-4da0-afe1-b0a204911aeb
# ╟─70e71241-e939-4b06-bcbe-ff7cf611df7a
# ╟─3e8baccf-799d-4694-99b0-9612bc59928f
# ╟─c986f65d-8031-490d-a0a9-e2e25a8b1310
# ╟─355989df-4aab-4c82-9e43-67123e9aecee
# ╟─9185f93e-3503-4dff-8133-8afd36fe148b
# ╟─fce5cf58-d66c-4fde-b6bb-854f745d1935
# ╟─8fa726b4-7064-4bd3-a2fa-54d875593009
# ╟─6c30ca52-f64e-400a-9a18-1639465c190e
# ╟─921402f8-a70c-4b45-b134-7fd70f0c699a
# ╟─034818e7-caae-495c-b159-e28549acd23a
# ╟─780b61fc-903e-4483-80d6-3cd927676589
# ╟─41d9d4e4-a4f0-425f-bb39-80a3c18d0289
# ╟─824dc5be-d6ab-4d43-8795-745dc4e10c8e
# ╟─b6f4724c-ed17-4edc-a565-6768fccde65f
# ╟─faaaae87-46e9-4fbd-82e0-6ac979f332ee
# ╟─69b9a76e-622c-4b69-bcdc-a0aae02a93eb
# ╟─3e23d630-4e11-4a52-8748-d66b02d1bfd4
# ╟─262590e2-745d-49ee-8c25-9e6f71a7b5bb
# ╟─7275809f-4e12-44aa-b7e1-ec9a2b33f870
# ╟─bb406003-2eb8-4e25-897e-7651fc1e719a
# ╟─caa6aae8-c3ab-40e2-a74b-a7241fabfc82
# ╟─36b43def-2c99-47a5-99c6-5d9b75884340
# ╟─d6441d19-d3d4-4d5e-9808-d93a258204f8
# ╟─c24ef65a-7dde-4f06-bfd0-c15e2f769822
# ╟─e014cbe2-51e1-4437-b6b1-4adc041e9e1a
# ╟─cc9f23dc-eaa0-4d19-b673-d147fbb57057
# ╟─2a7ce1ef-35e8-4553-85c3-15c98821bde6
# ╟─361360cb-bdf4-4f99-8ccc-3fee22847dd2
# ╟─3f716232-20c4-42fa-847d-e2bad3440e84
# ╟─3f4cdf58-95df-407d-a5f1-d4077d4b9188
# ╟─5fea7742-70a3-4a8e-892d-c70a953b0fcf
# ╟─66a6a32b-9639-4591-aca1-56742edca665
# ╟─7aa49db4-82df-4d28-81ae-7cf65fd3acc2
# ╟─23e7092b-6006-4ddd-97ff-454128a88e31
# ╟─1771917d-3f40-495d-ad52-50bf674ff0b6
# ╟─76d70fe8-358f-4f2f-9a00-69a147935282
# ╟─ff21805e-7466-4780-939b-72eeeee17e57
# ╟─e9cef70a-fbf9-47a7-b5c0-aa6bb2ec5f6c
# ╟─55c40cff-0639-46b5-a8dc-9f8cb3738a6f
# ╟─8953ae0b-ab82-4173-bda8-9980ae1ef550
# ╟─88bf0e46-17c9-4a61-9e82-9c113c1dbadd
# ╟─4e89c4d7-d4e8-4f68-ac5c-7b20d0c446e7
# ╟─06b01ce1-94dd-4ddd-ad17-2bdf3aa950ed
# ╟─2423e58f-2ff0-4c80-9666-ccb45243ae19
# ╟─e72cde3c-ad81-4242-8222-5d6bf86f22f4
# ╟─81e531a9-3afb-4c05-a138-133467882086
# ╟─ed5c3bc3-e514-4529-992c-ee1a4dc7ed7c
# ╟─201a91a8-4154-414e-86b1-ca578fa105c2
# ╟─27038fd7-4dc4-4dd5-87dd-0032478d0622
# ╟─62ec696b-021f-4756-aff8-f62a122345ae
# ╟─1480c3c4-7ef1-413b-9cd2-5bbb9f61a2e2
# ╟─2430b2d2-0343-4316-ae84-d7cc59759f00
# ╟─14e6f7ed-2a81-4101-a1b5-af627df7c805
# ╟─c6df6e6e-1c72-4fbb-b73c-7c084bc96b69
# ╟─7c923c8c-9067-42af-b103-391c05bbeb98
# ╟─ed31f60a-8b09-4222-8b81-333eccb33c02
# ╟─004efec5-23d3-4940-abff-9024820daf65
# ╟─fb7ad01e-1a12-4f06-a1a3-d1003cfea04a
# ╟─06b6deff-fb0a-4ed2-80ee-aee2cee7e0bf
# ╟─6edf15e1-fcad-42ed-a777-ab5be39e4a41
# ╟─cded3cca-c9ac-4d7d-b9dd-4c5497aa955e
# ╟─d4dab771-87f1-4fa2-b6a2-900a51af4586
# ╟─8f3a465e-af54-4b0e-9210-87c140629f2f
# ╟─d61da00e-9d8c-43e8-89c5-e70220dc761a
# ╟─049debc7-b1d5-4908-9b27-70344995a4c4
# ╟─abda6c84-f124-4d61-bb40-0517e28fbcf6
# ╟─72721c2c-f227-469a-91d9-dbec158c2fa7
# ╟─312e0229-445e-42d4-8a0d-709c590c1add
# ╟─97d9ba4b-880f-464e-bd94-7b72a86094b7
# ╟─bf6e7d0a-7e33-47b1-9240-a0af661057f5
# ╟─d16e82d8-faa9-444f-8db7-6f442c5e5fd4
# ╟─dc265679-85cd-4ff1-a728-6353f36e3a9c
# ╟─e36dc8d3-3b4e-46c4-9259-007f75068591
# ╟─4ac1725a-d9e5-4587-9b03-ae8b7379ed56
# ╟─00c3ea64-bbe5-4d7a-a1b2-1197b1455bec
# ╟─432dae1b-89b1-4e8a-b59a-98e00391b368
# ╟─d1eb23f3-7142-493d-b2e6-d4f844e2bfc6
# ╟─398086e4-4a4c-45f6-a32d-cb5d8847233c
# ╟─7c15360a-9f7f-45d0-8059-0420dc46b231
# ╟─cf85e64a-d5c4-4d04-b6ba-04ac003f7289
# ╟─a5a0c420-f28f-4ec4-a9e2-092a02cec9a8
# ╟─448fa11f-4bcb-4b62-9d1b-703d9a12786b
# ╟─d5ebca67-32b9-461d-9d4f-3285517c3cd2
# ╟─d5df1ae7-9cc5-453b-b889-cd57dcc671c4
# ╟─d9aa27ee-eba3-4dee-abeb-7fce49536793
# ╟─3d5a3bc4-f290-4d68-a5d4-ecdafc967537
# ╟─afc4f565-7171-4b47-93e0-ffa66386dedf
# ╟─7e50530e-a0ad-4709-9e89-bc7cc8575328
# ╟─5d53718b-a542-47ea-a4bf-7d94320d1fde
# ╟─6245fadd-8dda-4e59-b619-3b0cfe8fbafe
# ╟─bb34c7c8-4d9a-46c8-a1e4-38e01c3c404a
# ╟─31ef4b01-b5ed-47cc-9ff1-6d92ff7bd2b4
# ╟─d670b261-f427-4498-a8df-fcdacdb14d3e
# ╟─cba8fcb7-970e-47ef-9b0f-d4396e89aa66
# ╟─c6ae22ec-78cd-4a00-b36d-806439f9d550
# ╟─fde6eaee-dd08-483a-87c6-6778300c311d
# ╟─3936d198-5f63-4192-b33b-b1ef9941964d
# ╟─b415d609-0528-4e5f-9d43-bf8cd0e25688
# ╟─2bbcaee7-34a7-4596-ad38-5c6239dd08e6
# ╟─89516578-5de4-47b3-8629-89b590b15b19
# ╟─fbb7288e-806e-4fec-a9f6-cd79b66d33fd
# ╟─9cd0acc2-6e2b-42ac-9f92-1692d8b55d80
# ╟─60913481-91ed-4959-9b01-9fe363916045
# ╟─4e4f2c67-c86e-4e44-9eae-2c39f025c66d
# ╟─083a0cb1-a597-46ca-84c0-e5b7ce23b53a
# ╟─ad56ba09-a69c-40db-8caf-53efdd93719a
# ╟─e871ef6e-f4da-4cef-aecf-4103335ebead
# ╟─80176747-6460-4840-992f-394e1c1112b2
# ╟─b0b36b4c-9d44-42cf-a1c2-a97fad25b84e
# ╟─903a6516-2919-4078-89cc-264a726e07ca
# ╟─14623ccd-d970-4046-8e1c-89d1652e3bcf
# ╟─932c04a6-64e3-4d73-a083-c836fbafdbb3
# ╟─fb2d12f6-ebd2-4be5-9506-cdaa52cfaa1e
# ╟─d7e38a5e-2c88-4728-b1cc-d98a5e1a6ec1
# ╟─4950323f-1c91-4d63-b333-410c69650352
# ╟─8d63c259-14d0-45db-bd85-93b71e963dbb
# ╟─92383772-0e20-4302-89ca-ccb914a05a33
# ╟─03f0f3c5-cd48-4dec-b379-0d4245235f25
# ╟─0e8e476f-9933-4fd0-9ad6-b01f7918a67b
# ╟─7848436a-46e6-4456-8402-f34e3d16126b
# ╟─5cc070bc-e0f6-4158-a3e2-800acac61361
# ╟─9d03e1f6-4ad5-4b99-9ab8-cc92bff5f224
# ╟─a59495a8-a940-47b1-b240-685afbd62d23
# ╟─db457538-d9a1-4acd-be2a-d89e71c43864
# ╟─d72909ff-0908-4759-91be-ad420d7c47e3
# ╟─5ec83302-d399-49a5-86fe-514f30d76c7b
# ╟─9860adbf-82c4-4961-a0e4-dd5c51037430
# ╟─68cdb801-d6ca-4fe1-8510-5d66ac78e95e
# ╟─f4dc2755-9f58-4598-8216-e682f59f0632
# ╟─9b1b0269-d975-446a-a168-3db32d0fdb95
# ╟─43e04f32-6175-4a07-b128-427566259646
# ╟─294dde1d-2ce0-40d6-b309-b50f93b15c70
# ╟─59bdffc6-b6fd-45f7-98dc-aec5aab8b9a7
# ╟─342d06f0-bc3f-4da4-bfdc-7314fa927e9f
# ╟─4ca9e7a6-fa37-4df5-8941-4aa65af2822f
# ╟─0ae821cb-0914-42ac-95a2-b8f4d99e154a
# ╟─9b5dafa0-1ea6-482f-98a8-f2b8bfb7e9f0
# ╟─77b7030e-0cad-4d86-a70e-7896e0e45da7
# ╟─b00301af-7ee3-4266-9878-44616cba7ecd
# ╟─a89a9f56-8c94-47e0-9588-48ce9dcd97a4
# ╟─81506749-c1b6-4dac-beeb-d551698afb34
# ╟─9c8fe1c2-b148-4ded-b5ae-d9c512479a50
# ╟─932d7811-ebb5-4807-8270-afc8905e7b58
# ╟─3115e3a5-886e-4315-9c05-36cf9fe7692e
# ╟─73acdb08-b4d2-4e29-8004-1a936e72982f
# ╟─89d87124-23a2-4241-ad68-73b5be83106b
# ╟─803017a7-afa2-439a-96c5-ff42b49e25a3
# ╟─138a92e6-98bc-49d9-8ac1-2d75f41daaeb
# ╟─2c8ba6e2-83a9-4c4d-98a5-a1325fba7736
# ╟─29568bae-ed4f-4486-9c1f-6dbb234b5842
# ╟─26534a5e-a19b-4ef3-b4b3-1ab10700c601
# ╟─d95020e1-680f-44e5-9049-05202d247399
# ╟─c998015a-5254-48f3-b6f7-630c2e098656
# ╟─569d7b82-ee46-42e2-b24e-e22272769452
# ╟─b92d4665-551a-4824-8314-a59edc73fbad
# ╟─c87e3c57-f976-44b0-af02-c2f188a35db9
# ╟─53c77ef1-899d-47c8-8a30-ea38380d1614
# ╟─670e45a3-9d28-47ae-a6b6-a1b1c67a0a4c
# ╟─7c16c6a5-170d-4e4b-b18b-30db69eb9f6c
# ╟─2ee2c328-5ebe-488e-94a9-2fce2200484c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
