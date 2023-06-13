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

# ╔═╡ c3e429e4-e7e9-4db6-852c-906630f909a4
# ╠═╡ show_logs = false
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

# ╔═╡ 41d7b190-2a14-11ec-2469-7977eac40f12
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
	<p align=center style="font-size:25px; font-family:family:Georgia"> <b> Price-Quoting Conventions in the U.S. Treasury Market</b> <p>
	<p style="padding-bottom:1cm"> </p>
	<p align=center style="font-size:25px; font-family:family:Georgia"> June 2023 <p>
	<p style="padding-bottom:0.5cm"> </p>
	<div align=center style="font-size:20px; font-family:family:Georgia"> Prof. Matt Fleckenstein </div>
	<p style="padding-bottom:0.5cm"> </p>
	<div align=center style="font-size:20px; font-family:family:Georgia"> University of Delaware, 
	Lerner College of Business and Economics </div>
	<p style="padding-bottom:0cm"> </p>
	"""
end

# ╔═╡ 3e995602-7a5e-45ce-a31d-449951af1aea
TableOfContents(aside=true, depth=1)

# ╔═╡ 588d53c3-b0ca-4dd7-aa0d-f0054fdf2c34
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
        <input type="checkbox" value="">Understand how prices for Treasury securities are quoted in secondary markets.<br><br>
	    <input type="checkbox" value="">Know how to calculate accrued interest.<br><br>
	</fieldset>      
	"""
end

# ╔═╡ a1071aa2-3a5f-4e0b-a42a-38fa027a85d8
vspace

# ╔═╡ 16805b96-9bb1-4ac8-a6af-fb03c57f1352
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 1</div>
"""

# ╔═╡ 93db6880-429c-4b9c-a807-eba600e03df1
md"""
# Price Quotes for Treasury Notes/Bonds
"""

# ╔═╡ 1fa89db5-8185-4c32-81ad-4cc7e4ec44c4
md"""
## Example: 5-year Treasury Note in Bloomberg
- On the Bloomberg Terminal type `91282CCZ2` and click on the security in the search result. 
- Next, type `DES` and `Enter`.
"""

# ╔═╡ aac27a3c-e90a-437f-a563-f81d41c8d3f7
LocalResource("./TreasuryNoteDescrExampleBloomberg.png",:width => 1200) 

# ╔═╡ d3e308e6-b7f8-4f48-869f-f7dc34ec5b5b
vspace

# ╔═╡ 58ce2f05-63b2-45bc-8105-1cc709958e43
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 2</div>
"""

# ╔═╡ 39af52c6-ddb1-41ec-be5c-c0e31a2693bb
md"""
## Price Quotes for 5-year Treasury Note
- On the Bloomberg Terminal click on `ALLQ` under _Quick Links_
"""

# ╔═╡ 6561b7a0-368c-43c6-ada9-36b83dc4a749
LocalResource("./TreasuryNotePriceQuoteBloomberg.png",:width => 1000) 

# ╔═╡ 15cb9e60-6e54-4f0e-abb2-9249bdc49677
md"""
>- How to get there on the Bloomberg terminal?
>  - On the keyboard type `T Govt`
>  - Click on `United States Treasury Note/Bond (Multiple Matches) Govt`
>  - On the next page, click on one of the Treasury notes/bonds.
>  - Next, type `DES` on the keyboard and press enter.
>  - The page you now see is the `Description` page for the Treasury you selected.
>  - Next, type `ALLQ` and press enter.
>  - This will display a page with quoted prices for the Treasury note/bond you selected.
"""

# ╔═╡ 44e7c564-3738-4797-8904-b2bb709ac85e
vspace

# ╔═╡ 3e3c2581-333a-4be8-b07e-c9151a88fea7
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 3</div>
"""

# ╔═╡ 30ce6f74-1d7e-465d-abf1-245881fec53b
md"""
## Price Quotes for Treasury Coupon Securities
- Expressed as a percent of face value (often called “points”) and numbers after the hyphens denote 32$^{\textrm{nd}}$ (often called “ticks”).
"""

# ╔═╡ 4ad79093-2e8b-4fd7-bc1d-87388947ffde
md"""
!!! note ""
- Points: $(@bind p1 Slider(90:1:120, default=98, show_value=true))
- 32nd: $(@bind p2 Slider(10:1:31, default=26, show_value=true))
"""

# ╔═╡ 395335f3-3f6c-4fbc-bf0b-9a238c8b6864
Markdown.parse("
**Example**:
- Suppose the price of a Treasury note is quoted as **$(p1)**-**$(p2)**.
- For \$100 par value, the quoted price of **$(p1)**-**$(p2)** refers to a dollar price of $p1 dollars plus $p2 ``32^{\\textrm{nd}}`` of a dollar.
- In short, the price is calculated as 
	
\$$p1 + \\frac{$p2}{32} = $(roundmult(p1+p2/32.0, 1e-6))\$	
 
- This means that the price per \$ 100 par value is \$$(roundmult(p1+p2/32.0,1e-6)).
")

# ╔═╡ 5d8ae74b-2030-4dd1-a59b-4513304e8826
vspace

# ╔═╡ 8410957f-b423-479d-8171-d0890476f6f5
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 4</div>
"""

# ╔═╡ 46566086-d518-49d9-b173-f66f2ea0e131
md"""
The 32$^{\textrm{nd}}$ are themselves often split by the addition of a **plus** sign or a **third** digit. 
- ``+`` sign means that you add 1/64$^{\textrm{th}}$
- A _third_ digit means that you add the third digit divided by 256.
"""

# ╔═╡ f01f940c-233c-4b90-882b-bd9d33c6b841
md"""
!!! note ""
- Points: $(@bind p3 Slider(90:1:120, default=98, show_value=true))
- 32$^{\textrm{nd}}$: $(@bind p4 Slider(10:1:31, default=25, show_value=true))
"""

# ╔═╡ 2d37c722-c5bb-4462-a48d-f9374bed4449
Markdown.parse("
**Example**:
- Suppose the price of a Treasury note is quoted as **$(p3)**-**$(p4)+**.
- For \$100 par value, the quoted price of **$(p3)**-**$(p4)+** refers to a dollar price of $p3 dollars plus $p4 ``32^{\\textrm{nd}}`` plus 1 ``64^{\\textrm{th}}``of a dollar.
- In short, the price is calculated as 
	
\$$p3 + \\frac{$p4}{32} + \\frac{1}{64}= $(roundmult(p3+p4/32.0+1/64.0,1e-6))\$	
 
- This means that the price per \$ 100 par value is \$$(roundmult(p3+p4/32.0+1/64.0,1e-6))\$.
")

# ╔═╡ b541d16f-59da-48dd-b7f6-a0cebd451256
vspace

# ╔═╡ 62a7d222-c32b-47f0-9b8f-e4c732650281
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 5</div>
"""

# ╔═╡ b294a20b-8710-49bb-a069-75dbc3f19ba6
md"""
!!! hint ""
- Points: $(@bind p5 Slider(90:1:120, default=98, show_value=true))
- 32$^{\textrm{nd}}$: $(@bind p6 Slider(10:1:31, default=25, show_value=true))
- 256$^{\textrm{th}}$: $(@bind p7 Slider(1:1:9, default=2, show_value=true))
"""

# ╔═╡ 64adcfde-8ade-4778-bb01-9d46ee836a55
Markdown.parse("
**Example**:
- Suppose the price of a Treasury note is quoted as **$(p5)**-**$(p6)$(p7)**.
- For \$ 100 par value, the quoted price of **$(p5)**-**$(p6)$(p7)** refers to a dollar price of $p5 dollars plus $p6 ``32^{\\textrm{nd}}`` plus $(p7) ``256^{\\textrm{th}}``of a dollar.
- In short, the price is calculated as 
	
\$$p5 + \\frac{$p6}{32} + \\frac{$p7}{256}= $(roundmult(p5+p6/32.0+p7/256.0,1e-6))\$	
 
- This means that the price per \$ 100 par value is \$$(roundmult(p5+p6/32.0+p7/256.0,1e-6))\$.
")

# ╔═╡ c3f25830-c6d2-4d77-bbd6-91024ee3363b
vspace

# ╔═╡ 0ee241a7-4dd4-4d7a-9f7f-1fc1691747b4
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 6</div>
"""

# ╔═╡ f72ab26d-f986-4ab3-9f15-11cb33b65c69
md"""
!!! hint ""
- Points: $(@bind p11 Slider(90:1:120, default=98, show_value=true))
- 32$^{\textrm{nd}}$: $(@bind p12 Slider(10:1:31, default=25, show_value=true))
- Quarters of a 32$^{\textrm{nd}}$: $(@bind p13 Slider(1:1:3, default=1, show_value=true))
"""

# ╔═╡ e68723a6-a1d8-4a3f-8ba0-9acab5d764db
Markdown.parse("
**Example**:
- Often, trading system such as Bloomberg display _fractions_ after the ``32^{\\textrm{nd}}``.
- Suppose the price of a Treasury note is quoted as ``\\mathbf{$p11 - $p12 \\frac{$p13}{4}}``.
- For \$100 par value, the quoted price of ``\\mathbf{$p11 - $p12 \\frac{$p13}{4}}`` refers to a dollar price of $p11 dollars plus ``($p12 + \\frac{$p13}{4})`` ``32^{\\textrm{nd}}`` of a dollar.
- In short, the price is calculated as 
	
\$$p11 + \\frac{$p12+\\frac{$p13}{4}}{32} = $(roundmult(p11+(p12+0.25*p13)/32.0,1e-6))\$	
 
- This means that the price per \$ 100 par value is \$$(roundmult(p11+(p12+0.25*p13)/32.0,1e-6))\$.
")

# ╔═╡ bbf515d0-e8a2-4391-8e86-41e814e3240a
vspace

# ╔═╡ 487c73a8-ee36-4fbe-95ea-12bcd86dc974
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 7</div>
"""

# ╔═╡ b5ed2793-df92-4f41-97e9-7533b35db4c0
md"""
!!! hint ""
- Points: $(@bind p14 Slider(90:1:120, default=98, show_value=true))
- 32$^{\textrm{nd}}$: $(@bind p15 Slider(10:1:31, default=25, show_value=true))
- Eights of a 32$^{\textrm{nd}}$: $(@bind p16 Slider(1:1:7, default=1, show_value=true))
"""

# ╔═╡ b65c747b-f08a-408d-8e01-e921dcbd9056
Markdown.parse("
**Example**:
- One last example. Suppose the price of a Treasury note is quoted as ``\\mathbf{$p14 - $p15 \\frac{$p16}{8}}``.
- For \$100 par value, the quoted price of ``\\mathbf{$p14 - $p15 \\frac{$p16}{8}}`` refers to a dollar price of $p14 dollars plus ``($p15 + \\frac{$p16}{8})`` ``32^{\\textrm{nd}}`` of a dollar.
- In short, the price is calculated as 
	
\$$p14 + \\frac{$p15+\\frac{$p16}{8}}{32} = $(roundmult(p14+(p15+1/8*p16)/32.0,1e-6))\$	
 
- This means that the price per \$ 100 par value is \$$(roundmult(p14+(p15+1/8*p16)/32.0,1e-6))\$.
")

# ╔═╡ 2200d50b-f23f-4764-85e1-d908b5aeeb1e
vspace

# ╔═╡ e006ee99-b2e5-4705-83be-8846a14f3af7
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 8</div>
"""

# ╔═╡ 4576f508-91bd-4fdc-a62d-833d8428f78f
md"""
## Practice Exercise
For each quoted price shown below, enter the price per \$100 par value in decimals.
"""

# ╔═╡ 6c57bd92-7d1d-41d3-88d5-0b2c191b7693
# ╠═╡ show_logs = false
begin
	p161=100
	p162=27
	
	p171=108
	p172=31
		
	p181=102
	p182=12
	p183=3
	
	p191=102
	p192=18
	p193=1
	display("")
end

# ╔═╡ 9a1aa162-d274-4af7-8f13-5a9d6bab98b0
Markdown.parse("""
- Quoted Price: ``$p161 - $p162`` 
""")

# ╔═╡ 4bccc40c-953a-4969-b47b-aea4b234919b
html"""
<p style="padding-bottom:2.5cm;background-color: #f2f3f4;border-style: solid; border-width: thin;"> </p>
"""

# ╔═╡ 176d61b1-02d9-4da6-a893-72aca3541f2c
vspace

# ╔═╡ 16c0a1d7-2454-466f-8700-d8c67fb53955
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 9</div>
"""

# ╔═╡ 729198d1-5795-4b70-85f8-f25717edc244
Markdown.parse("""
- Quoted Price: ``$p171 - $p172 +`` 
""")

# ╔═╡ 301c4a13-814e-4853-aa5b-aac611cc40f0
html"""
<p style="padding-bottom:2.5cm;background-color: #f2f3f4;border-style: solid; border-width: thin;"> </p>
"""

# ╔═╡ feb4fbca-0a01-445a-b4e1-d50b3f3525a3
vspace

# ╔═╡ 38981253-e191-4e30-9047-0723e1364978
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 10</div>
"""

# ╔═╡ 9aa0dec2-c1e1-41c5-9ad5-35b51e41128a
Markdown.parse("""
- Quoted Price: ``$p181 - $p182 \\frac{$p183}{4}`` 
""")

# ╔═╡ 3a2a5dea-4a07-4368-89c9-cde995b9964b
html"""
<p style="padding-bottom:2.5cm;background-color: #f2f3f4;border-style: solid; border-width: thin;"> </p>
"""

# ╔═╡ d79b4d61-8211-4fca-a83c-46db3959d51e
vspace

# ╔═╡ 90195978-ac91-4efb-9df0-2403568e9e5b
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 11</div>
"""

# ╔═╡ a4670db5-20e5-41cd-a2af-8dd15ce119f6
Markdown.parse("""
- Quoted Price: ``$p191 - $p192 \\frac{$p193}{8}`` 
""")

# ╔═╡ 16d95a82-743e-478c-a50d-36e800910883
html"""
<p style="padding-bottom:2.5cm;background-color: #f2f3f4;border-style: solid; border-width: thin;"> </p>
"""

# ╔═╡ 069242d7-b08b-423d-8e38-b5b0b690b8b1
vspace

# ╔═╡ fa72f9cb-f8e6-4886-8cea-1d53a195067b
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 12</div>
"""

# ╔═╡ be1e2ae2-8b05-42c7-bc54-18c9ff111854
md"""
# Accrued Interest
"""

# ╔═╡ 8464e17a-2f95-4bde-8c37-502359bb2dd8
LocalResource("./TreasuryNoteDescrExampleBloomberg_2.png",:width => 1200) 

# ╔═╡ 59023ef2-e4fb-4e41-9652-67f6a107e1b1
vspace

# ╔═╡ 4167b3d7-9ac5-45b2-86c9-daa8ce12f93b
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 13</div>
"""

# ╔═╡ a7c9120b-ee24-48c2-904a-e40ef95fcffa
LocalResource("./TreasuryNoteDescrExampleBloombergDirtyPrice_2.png",:width => 1200) 

# ╔═╡ 148712ae-b638-45de-9ab1-96492f083439
vspace

# ╔═╡ b7ea3fc2-5711-450e-a8d3-92bf19fd379e
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 14</div>
"""

# ╔═╡ 8f9498b5-a1cf-4be7-b0dd-41aad76c959b
md"""
- U.S. Treasury securities pay coupon interest every six months.
- At any date between two coupon payments, we must take the **accrued interest** into account.
- The convention in the Treasury market is that _in addition to_ the **quoted price**, the bond buyer must _pay_ the bond seller the **accrued interest**.
- Thus, the amount that the buyer pays the seller is the **quoted price** plus **accrued interest**.
  - This is the actual purchase price and it is called the **dirty price.**
  - The **quoted price** of a bond (_without accrued interest_) is called the **clean price.**
- The **clean price** is also called the **flat** price and the **dirty price** is also called the **full** price.
"""

# ╔═╡ 061b60b1-7c34-4a05-8f9f-89bb53e76923
vspace

# ╔═╡ 5b92a84b-ceed-4470-8768-aaa43746e9ea
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 15</div>
"""

# ╔═╡ 6ce18679-b433-4110-8ef4-0fd9135737f4
md"""
> - How to get there on the Bloomberg terminal?
>   - On the keyboard type `T Govt`
>   - Click on `United States Treasury Note/Bond (Multiple Matches) Govt`
>   - On the next page, click on one of the Treasury notes/bonds.
>   - Next, type `DES` on the keyboard and press enter.
>   - The page you now see is the `Description` page for the Treasury you selected.
>   - Next, type `HP` and press enter.
>   - This will display a page with past prices for the Treasury note/bond you selected.
>   - Next, at the top, in the row labeled `Market` type in __Mid Line__ in the first field and __Dirty Mid Price__ in the second field. Press enter.
>   - The price table will now show the *clean* mid price and the *dirty* mid price.
>     - Recall that the *mid* price is the midpoint between the bid and the ask price.  
"""

# ╔═╡ c391eb33-e269-47dc-be8c-df8dcea7828d
vspace

# ╔═╡ ed64ace8-a973-40e6-af92-d16876d7ac15
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 16</div>
"""

# ╔═╡ 1c3d5c02-4be2-4aff-bac8-bfde4aca679a
md"""
## Full Prices of Treasury Notes/Bonds over Time
"""

# ╔═╡ c90f441d-09ca-4562-8f3f-d766e166d2a4
md"""
On the coupon payment data, the Treasury trades `ex-coupon` and its *full price* (also referred to as the *dirty price*) drops by the amount of the coupon interest cash flow.
"""

# ╔═╡ ee211d3e-08c0-4a4c-8c79-8d5e709981ef
LocalResource("./BloombergTreasuryDirtyPricePath.png", :width=>1200)

# ╔═╡ 2978a148-a9ef-4f78-a416-2dec50d25503
vspace

# ╔═╡ b8026e29-5966-4cdd-84bc-33081f1775b7
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 17</div>
"""

# ╔═╡ 90501d6d-5c09-4bae-9415-dedd93dca242
LocalResource("./BloombergTreasuryDirtyPricePath_02.png", :width=>1200)

# ╔═╡ d440a3c8-6c8b-4eb9-ab4d-266917d50ee0
md"""
- The screenshot shows that the price change on the ex-coupon date is `0-28`.
- This is a dollar price (per \$100 notional) of $\frac{28}{32}=$ \$0.875.
- The Treasury note has a coupon rate of `1-3/4` percent (see the top left).
- In decimals, this is a couponr ate of 1.75%.
- Thus, the semi-annual coupon cash flow per \$100 face value is $\frac{1.75}{2}\ \times 100$ = \$0.875.
- Thus, the price decline matches the dollar coupon interest paid on this day.
"""

# ╔═╡ d2d64702-6cce-4ffb-bdc2-928112af47c1
vspace

# ╔═╡ 3e793413-8c09-472b-8e76-768bdac21e19
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 18</div>
"""

# ╔═╡ 18026407-34e8-4a96-aaaf-410d495f9568
md"""
## Example
"""

# ╔═╡ d31d75cb-142f-4e62-ab2c-80c2e19044b8
vspace

# ╔═╡ 864a77be-3ff8-4881-8c5b-944126cd3874
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 19</div>
"""

# ╔═╡ 6fe25adf-8dd4-4391-ba0e-6224887dbf07
vspace

# ╔═╡ 9afffb09-8178-44df-bbf2-6c3ca4c15d11
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 20</div>
"""

# ╔═╡ 2cf47487-36c3-4a28-976e-06a58675b306
vspace

# ╔═╡ 5726e8ce-f069-4557-9d3b-533f211abc4a
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 21</div>
"""

# ╔═╡ 6acadc8a-dbb7-4193-9df7-09504755476b
md"""
!!! hint ""
- Days between coupon payments: 180
- Coupon rate [% p.a.]: $(@bind cpnAI_1 Slider(0:1:10, default=2, show_value=true))

- Days after previous coupon: $(@bind daysAI_1 Slider(1:1:180, default=60, show_value=true))
- Days to next coupon: $(180-daysAI_1)
"""

# ╔═╡ 362273d3-e019-4953-a1dd-21699f7a7def
Markdown.parse("""
- To illustrate, suppose a Treasury note has a coupon rate of $(cpnAI_1) % (paid semi-annually) and that there are 180 days between coupon payments.
- Suppose you **own** \$ 100 par value of this Treasury note and that $(daysAI_1) days have passed since the previous coupon cash flow.
- The next coupon cash flow in $(180-daysAI_1) days is 
\$\\frac{$cpnAI_1\\%}{2} \\times 100 = $((cpnAI_1/100)/2*100)\$	

""")

# ╔═╡ 20fc5dfa-55a2-4b90-b57d-9e57e2430ae1
Markdown.parse("""
- Now, suppose you decide to sell the Treasury note.
- When you sell the Treasury note, you no longer receive the coupon cash flow in $(180-daysAI_1) days. 
- The buyer receives the full coupon interest of \$ $((cpnAI_1/100)/2*100).
- However, you owned the bond for $(daysAI_1) out of the 180 days between coupon interest cash flows.
- Thus, you should be entitled to receive a fraction equal to \$\\frac{$daysAI_1}{180} = $(roundmult(daysAI_1/180,1e-2))\$ of the total  $((cpnAI_1/100)/2*100) coupon interest.

""")

# ╔═╡ 872bc4a3-9f35-463f-8894-57424c280260
Markdown.parse("""
- This amount of \$ $(roundmult(daysAI_1/180 * (cpnAI_1/100)/2*100,1e-2)) is referred to as **accrued interest** and it is added to the *quoted* price.
- The total price paid by the buyer is called the **full price** or the **dirty price**.
- The quoted price (without accrued interest) is called the **flat price** or the **clean price**.
- Thus,
\$\\textrm{Full Price}=\\textrm{Flat Price} + \\textrm{Accrued Interest}\$
\$\\textrm{or}\$
\$\\textrm{Dirty Price}=\\textrm{Clean Price} + \\textrm{Accrued Interest}\$
""")

# ╔═╡ 577c5da8-de61-4f41-96f3-957c4fa93cd2
begin
	
	daysAI_2 = repeat(collect(0:179),3)
	cpnAI_2 = ((cpnAI_1/100)/2*100).*daysAI_2/180
	plot(cpnAI_2,xticks = ( [0:30:length(daysAI_2);], string.(daysAI_2[1:30:end])),
		ylabel="Accrued Interest",xlabel="Days since last coupon", label=""
	)
	
	 
end

# ╔═╡ 730a767d-f4e7-49a9-b830-9a22822733c9
vspace

# ╔═╡ c800fc20-b59f-4072-ac64-79701ac75471
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 22</div>
"""

# ╔═╡ cedc6044-5eb2-4e95-98c7-e5831597a258
md"""
## Calculating Accrued Interest for Treasury notes and bonds
"""

# ╔═╡ d43ce5da-dee3-4d44-a202-4f5f4770772b
md"""
- To calculate accrued interest, the following are needed: 
  - the **number of days in the accrued interest period** (represents the number of days over which the investor has earned interest)
  - the **number of days in the coupon period** (representes the number of days between the last and the next coupon payment)
  - the **dollar amount of the coupon payment**
"""

# ╔═╡ 6130561b-7f4b-4982-b3b0-07a82f40cd0f
vspace

# ╔═╡ 9b6610ed-ae6e-4838-86fb-4835d40e9c11
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 23</div>
"""

# ╔═╡ a4a0a069-80d6-4a13-a19d-56b200ca8545
md"""
!!! terminology "Accrued Interest"
- Accrued Interest is the calculated as
$$\textrm{Accrued Interest} = \textrm{Coupon Interest Cash Flow} \times \left( \frac{ \textrm{Days in Accrued Interest Period}}{\textrm{Days in Coupon Period}} \right)$$
"""

# ╔═╡ 4491ba36-5eee-4b03-b056-da014bde0745
vspace

# ╔═╡ 6d6eb212-6e5c-4597-82e7-799798f05362
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 24</div>
"""

# ╔═╡ b71c4b72-7004-4600-82d4-651179178a03
md"""
## 1. Calculate the **Days in Accrued Interest Period**

- We need three key dates: 
- **Trade date**
  - The trade date (also referred to as the transaction date) is the date on which the transaction is executed (referred to as “T”).
- **Settlement date** 
  - The settlement date is the date a transaction is deemed to be completed and the seller must transfer the ownership of the bond to the buyer in exchange for the payment.
  - Treasury securities settle on the next business day after the trade date. This is referred to as *T+1 Settlement*.
- **Date of previous coupon cash flow**
- Days in Accrued Interest Period are then calculated as


"""

# ╔═╡ a0b7115c-d6e5-4866-9e04-946e53e4c0c6
md"""
!!! terminology "Days in Accrued Interest Period"
$$\textrm{Days in Accrued Interest Period=}$$ 
$$\textrm{Days from and \textbf{including} the previous coupon date up to \textbf{excluding} the settlement date}$$
"""

# ╔═╡ 0a49e623-79aa-4a8e-b35f-1efbfc342bef
vspace

# ╔═╡ 9360f593-37b6-4fbb-a1ea-7f6bcda0009a
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 25</div>
"""

# ╔═╡ fd4aead4-bf25-4125-b094-6edce0e77b1e
md"""
## 2. Calculate the **Days in Coupon Period**
- Simply the number of days between the previous coupon date and the next coupon date.
"""

# ╔═╡ 8e6ba2c0-65b0-4786-85cc-7025d9822b1c
vspace

# ╔═╡ 034067e2-9093-413b-bdcf-5e00ea0a4c56
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 26</div>
"""

# ╔═╡ fcaff09a-c014-4fe9-81f8-f0fb72d99829
md"""
## Accrued Interest Example 1
"""

# ╔═╡ 8323c2cc-cc29-416b-aca4-798f7cc844ed
md"""
- Consider a Treasury note whose previous coupon payment was on May 15. Assume that the coupon rate is 8% p.a. (paid semi-annually) and par value of \$100.
  - Thus, the coupon interest cash flows are $\frac{8\%}{2}\times 100 =$ \$4
- Suppose you buy Treasury security with a settlement date of September 10.
- Since Treasury notes pay semi-annual coupon interest, the next coupon payment is on November 15. 
"""

# ╔═╡ e4333cc8-9d61-4df9-b3a9-d022ae9e43ee
vspace

# ╔═╡ 0a736d43-fc20-46ec-8cb4-01f16a44fd5e
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 27</div>
"""

# ╔═╡ 9119860b-2ada-411a-95e7-e1e56ae573c0
md"""
##
- **Step 1**: *Days in Accrued Interest Period*
  - We count the actual number of days between May 15 (the previous coupon date) and September 10 (the settlement date). 
    - May: **17** days (we count the day of the previous coupon cash flow)
    - June: 30 days
    - July: 31 days
    - August: 31 days
    - September: **9** days (we do not count the settlement date)
   - Thus, *Days in Accrued Interest Period* = 118
"""

# ╔═╡ 67ddec44-a377-47eb-9e9e-1f53b88213d5
vspace

# ╔═╡ 74217076-17c8-4d6c-91d5-07d7c01d0d55
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 28</div>
"""

# ╔═╡ 8dc2cccb-a682-4c42-99fe-ccc91d3823d1
md"""
##
- **Step 2**: *Days in Coupon Period*
  - We count the actual number of days between May 15 (the previous coupon date) and Nov 15 (the next coupon date)
    - May: **16 days**
    - June: 30 days
    - July: 31 days
    - August: 31 days
    - September: 30 days
    - October: 31 days
    - November: **15 days**
  - Thus, *Days in Coupon Period*=184
"""

# ╔═╡ 50c74e0f-3cca-4b17-974f-af470fd3079e
vspace

# ╔═╡ e74dfc8b-54a1-4e4a-ab0b-de1562ce197a
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 29</div>
"""

# ╔═╡ c6df152f-9f62-4eb4-997e-afd9a0868c9e
md"""
##
- **Step 3**: *Accrued Interest*
$$\textrm{Accrued Interest} = \textrm{Coupon Interest Cash Flow} \times \left( \frac{ \textrm{Days in Accrued Interest Period}}{\textrm{Days in Coupon Period}} \right)$$
$$\textrm{Accrued Interest} = \textrm{\$4} \times \left( \frac{ \textrm{118}}{\textrm{184}} \right) = \textrm{\$4} \times 0.641304 = \textrm{\$2.565217}$$
"""

# ╔═╡ b32585ce-1455-4129-ba58-f0a00b9b1c3a
vspace

# ╔═╡ 0e493d71-bf2e-4300-bd14-2301bdad9efb
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 30</div>
"""

# ╔═╡ 41b91a85-ac56-4b36-87e1-b121c756417e
md"""
## Accrued Interest Example 2
"""

# ╔═╡ 7c6e09d1-f31b-4e38-933f-5a21c5428721
vspace

# ╔═╡ fee22538-6370-4cb9-8c46-8e0143a9036c
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 31</div>
"""

# ╔═╡ 041eb11a-9da2-4e28-ace6-e20a13482c7d
html"""
<p style="padding-bottom:2.5cm;background-color: #f2f3f4;border-style: solid; border-width: thin;"> </p>
"""

# ╔═╡ bbc947d4-0c02-4398-8daa-72d64f00b6a3
html"""
<p style="padding-bottom:2.5cm;background-color: #f2f3f4;border-style: solid; border-width: thin;"> </p>
"""

# ╔═╡ cfd69cc4-d5aa-4c85-89aa-1356e24cf8b0
html"""
<p style="padding-bottom:2.5cm;background-color: #f2f3f4;border-style: solid; border-width: thin;"> </p>
"""

# ╔═╡ afe4eecf-c83b-4ba1-9539-01bb4c05e8cd
vspace

# ╔═╡ a459705c-ac04-4bec-a723-4cdc63a49cb3
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 32</div>
"""

# ╔═╡ 4d039efd-c682-4abe-a2a4-8536ed97a3c7
# ╠═╡ show_logs = false
begin
	md"""
	- Coupon rate [% p.a.]: $(@bind cpnAI_3 Slider(0:0.25:10, default=2.5, show_value=true))
	- Par value [\$]: $(@bind par_3 Slider(100:100000, default=100, show_value=true))
	- Previous coupon cash flow date: $(@bind prev_3 DateField(default=Date(2015,7,15)))
	- Next coupon cash flow date: $(@bind next_3 DateField(default=Date(2016,01,15)))
	- Settlement date: $(@bind settle_3 DateField(default=Date(2015,10,10)))
	"""
	daysAIPeriod = Date(settle_3) - Date(prev_3)
	daysCpnPeriod = Date(next_3) - Date(prev_3)
	accrInt_3 = Dates.value(daysAIPeriod)/Dates.value(daysCpnPeriod)*cpnAI_3/(200)*
par_3
	display("")
end

# ╔═╡ df9c4a93-ceac-4ea9-8121-09affb1d534a
Markdown.parse("""
- Suppose a Treasury note is traded with settlement date on $(Date(settle_3)).
- The Treasury note has a coupon rate of $(cpnAI_3) % (paid semi-annually).
- The previous coupon was paid on $(Date(prev_3)).
- Since coupons are paid every six months, there are six months between coupon payments. Thus, the next coupon will be paid on $(Date(next_3)).
- Calculate the accrued interest.
""")

# ╔═╡ 7b376a7e-215e-40af-82af-6be2762aa7eb
Markdown.parse("""
!!! hint
- Plugging in the numbers gives us the accrued interest:

``\\begin{align}
	\\textrm{Accrued Interest} &= \\textrm{Coupon Interest Cash Flow} \\times \\left( \\frac{ \\textrm{Days in Accrued Interest Period}}{\\textrm{Days in Coupon Period}} \\right)\\\\ 
	&= \\\$ $(roundmult(cpnAI_3/(200)*par_3,1e-6)) \\times \\frac{$(Dates.value(daysAIPeriod)) \\textrm{ days}}{$(Dates.value(daysCpnPeriod)) \\textrm{ days}} =\\\$ $(roundmult(accrInt_3,1e-6))
	\\end{align}``
""")

# ╔═╡ 54a2b6c4-43b3-4d38-b9c7-75fb10976b90
vspace

# ╔═╡ 3751f38e-9a40-4d76-9d7e-b463721cb82d
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 33</div>
"""

# ╔═╡ 70661dd7-0acf-4b6c-b7dd-f4ad71c1cee9
md"""
# Daycount Conventions
- In calculating the number of days between two dates, the actual number of days is **not** always the same as the number of days that should be used in the accrued interest formula.
- The number of days used depends on the **day count convention** for the particular security.
- For Treasury notes/bonds, the day count convention is to use the **actual** number of days between two dates.
  - This is referred to as the **actual/actual** day count convention.
"""

# ╔═╡ c40c66fe-2456-4403-bba1-6c636fbee403
vspace

# ╔═╡ b3cf7cb4-3f9c-4d29-a061-e83987b93661
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 34</div>
"""

# ╔═╡ 6e1be79b-bfc7-444e-b660-e0d24a2cf5dd
md"""
##
- For coupon-bearing agency, municipal, and corporate bonds, a different day count convention is used.
- It is assumed that every month has **30 days**, that any 6-month period has **180 days**, and that there are **360 days** in a year.
- This day count convention is referred to as **30/360.**
- The calculations are analogous to the examples we covered, except that 30 days are used for each month.
"""

# ╔═╡ dc630486-a6f2-421b-b7f4-ff5f1b331485
vspace

# ╔═╡ 4bfa145f-af60-4364-87dd-eba26b00a013
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 35</div>
"""

# ╔═╡ e4c4606f-bb51-43c6-98b7-73e1b133b251
md"""
##
- To illustrate the “30/360” convention, suppose the **settlement date** is *July 17* and the *previous coupon cash flow* was on *May 15*.
- The number of days between May 15 and July 17 is 62 days, 
  - May is assumed to have 30 days. Thus we count 16 days in May (remember to include the date of the previous coupon cash flow).
  - The month of June is assumed to have 30 days, so we add 30 days.
  - In July, we count 16 days (remember to exclude the settlement date)
  - So the total number of days is 16 days + 30 days + 16 day = 62 days.
"""

# ╔═╡ 033c762c-2511-4185-86e4-b2ec5b181276
vspace

# ╔═╡ 156362e6-1a95-4fa1-97a0-a48397b4ad68
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 36</div>
"""

# ╔═╡ a81f9bd5-374d-4238-af83-e39ab1f5982e
md"""
# Price Quotes of Treasury Bills
"""

# ╔═╡ bb8b0b23-4313-4764-96bd-c1e34aa09795
md"""
## Example: 52-week Treasury Bill in Bloomberg
- On the Bloomberg Terminal type `912796M89` and click on the security in the search result. 
- Next, type `DES` and `Enter`.
"""

# ╔═╡ a93b91d5-7239-4260-b57f-7afb02ee31c5
LocalResource("./TreasuryBillDescrExampleBloomberg.png",:width => 1200) 

# ╔═╡ 03a7b4ed-a4ee-4d87-af1e-958c249c89c9
vspace

# ╔═╡ a048f9e6-4826-41f6-828e-e585a9ac4d79
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 37</div>
"""

# ╔═╡ dcb12edc-553b-4fe7-9525-a86d9fd5a78a
md"""
## Price Quotes for 52-week Treasury Bill
- On the Bloomberg Terminal click on `ALLQ` under _Quick Links_
"""

# ╔═╡ 25500a55-9c69-42d8-87bf-fb897b6de939
LocalResource("./TreasuryBillPriceQuoteBloomberg.png",:width => 1200) 

# ╔═╡ 71684c1d-0204-477b-a838-175f38e8c367
md"""
>- How to get there on the Bloomberg terminal?
>  - On the keyboard type `B Govt`
>  - Click on `United States Treasury Bill (Multiple Matches)`
>  - On the next page, click on one of the Treasury bills.
>  - Next, type `DES` on the keyboard and press enter.
>  - The page you now see is the `Description` page for the Treasury bill you selected.
>  - Next, type `ALLQ` and press enter.
>  - This will display a page with quoted prices for the Treasury bill you selected.
"""

# ╔═╡ 05a80ef2-a74c-4fcc-ac5b-62953b8308b2
vspace

# ╔═╡ 5f2426ae-372f-4f12-b179-fb9f09e554ef
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 38</div>
"""

# ╔═╡ 9d874ab6-e3ec-4a87-8842-a8a8074b745c
md"""
## Treasury Bill Price Quoting Convention
"""

# ╔═╡ a92a604a-429b-4508-9820-c99839f3b431
md"""
- The convention for quoting prices for Treasury bills is **not** the same as for Treasury bonds.
- Treasury bill prices are quoted as yields on **bank discount basis**.
- The yield on a bank discount basis $y_d$ for $100 par value is computed as follows: 
"""

# ╔═╡ 14053ee7-5149-485b-940a-6238b837ba68
md"""
!!! terminology "Treasury Bill Yield"
$$y_d = \frac{100-\textrm{Price}}{100} \times \left( \frac{360}{\textrm{Days to Maturity}} \right)$$
"""

# ╔═╡ ab013f3d-433b-4511-b8df-349e9ce40691
md"""
- where $\textrm{Price}$ is the purchase price of the Treasury bill and $\textrm{Days to Maturity}$ is the number of days until the maturity date of the Treasury bill.

"""

# ╔═╡ f214cc4b-384f-4e81-8de6-7a7f5d3ccf20
vspace

# ╔═╡ 549ff932-c2d7-4ab3-9e02-1b3c924a4482
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 39</div>
"""

# ╔═╡ 6c60f875-a3e2-44d8-92b6-076ad2b474ca
md"""
- In calculating the $\textrm{Days to Maturity}$ Treasury bills use the **actual/360** convention.
  - Thus, the number of days between two dates is the **actual** number of days.
  - Each year is assumed to have **360** days.
- Note that the term in the numerator is essentially the dollar **discount** (the difference between par value and the purchase price).
"""

# ╔═╡ ca7965dd-de83-4723-8f5f-139b2ad49de1
vspace

# ╔═╡ de23b86d-91b7-4f5a-bf0a-d07afb50ac78
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 40</div>
"""

# ╔═╡ 4f6af650-763a-4c56-a564-d3c1447be1fd
Markdown.parse("
## Example Calculating the Discount Yield given the Price
- Consider a Treasury bill with 85 days to maturity, a face value of 100, and a purchase price of 99.10.
- Calculate the discount yield \$y_d\$.
")

# ╔═╡ ec502b63-cefb-4576-9ae2-65ac39d6bc85
html"""
<p style="padding-bottom:2.5cm;background-color: #f2f3f4;border-style: solid; border-width: thin;"> </p>
"""

# ╔═╡ 3d8f424f-f097-4d46-b23e-d490455951a7
vspace

# ╔═╡ 9ebb7800-3463-43a5-ba5c-364c4f61742f
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 41</div>
"""

# ╔═╡ 28112b4a-fbeb-4409-b3f7-88578191a704
md"""
## Example Calculating Price given the Discount Yield
"""

# ╔═╡ 443d90d3-a408-4f0a-b1c0-8e2cdfc1970a
md"""
- Let us now consider the possibly more typical case where we want to know the dollar price given a discount yield quote from the Bloomberg system.
"""

# ╔═╡ 06d1335e-2596-4e97-98b4-744376238133
vspace

# ╔═╡ 2abaa6d1-3bc5-4bdb-ba74-77a4bc498c04
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 42</div>
"""

# ╔═╡ e2e15eb3-c339-49ea-85b6-5436835cddea
md"""
Example from Bloomberg of the Treasury Bill with maturity on 4/30/2020
- Quote (as discount yield) on 2/07/2020.
- Settlement date is 2/10/2020.
- There are 80 days from settlement date to maturity.
  - Note that there are 29 days in February of 2020.
  - Thus, 19 days in February + 31 days in March + 30 days in April = 80 days.
"""

# ╔═╡ 448e7b7e-b4b7-4eec-a331-f72f6aac7ff2
LocalResource("./TbillExampleBloomberg_1.svg",:width => 1200) 

# ╔═╡ 4044d433-857f-47f6-8947-597935a981a1
vspace

# ╔═╡ 9b5ad19e-7e8c-4be0-8f9a-8fe4022765de
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 43</div>
"""

# ╔═╡ 61228793-317c-40a2-b9f8-cb661704f799
md"""
Quoted discount yield on 02/07/2020.
"""

# ╔═╡ e88cafc2-ad9a-4c46-bbc6-2f442ce0615a
LocalResource("./TreasuryBillPriceQuoteBloomberg_3.svg",:width => 300) 

# ╔═╡ 2ecb026c-c7ea-41a4-ac2b-b518b7fd5f05
vspace

# ╔═╡ 08083ddf-973d-4040-8878-f20fa484cb86
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 44</div>
"""

# ╔═╡ 7b091f73-2454-4690-b1f9-3f0008561da9
md"""
What is the purchase price?
- Simply solve the equation for the discount yield $y_d$ for the price.
"""

# ╔═╡ a57f4d3f-e954-41fa-88a6-8d036a65ef07
md"""
!!! terminology "Treasury Bill Price"
$$P = 100 \times \left( 1- y_d \times \frac{\textrm{Days to Maturity}}{360}\right)$$
"""

# ╔═╡ d5c4c319-a544-4546-847f-f5f384ee4494
vspace

# ╔═╡ 8128bfd1-aea6-42df-b05a-b3e4321cc879
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 45</div>
"""

# ╔═╡ 574ee503-37f4-4d27-8bc2-7688b60fe839
md"""
- Using the quoted discount yield, calculate the price of the Treasury bill.
"""

# ╔═╡ d0b9d5ee-9120-4273-b8fc-714295bf8063
html"""
<p style="padding-bottom:2.5cm;background-color: #f2f3f4;border-style: solid; border-width: thin;"> </p>
"""

# ╔═╡ 2e81e8dc-cdef-4965-84a4-bdd1513d09f9
vspace

# ╔═╡ f5f158d2-2378-4297-8072-ac00530980a1
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 46</div>
"""

# ╔═╡ 80e6068f-5876-47c0-a5e8-17125b54de63
md"""
- Let's verify
"""

# ╔═╡ d11d60be-9909-47c6-8ce9-438e2cf28d6f
LocalResource("./TreasuryBillPriceQuoteBloomberg_2.svg",:width => 300) 

# ╔═╡ 9cc1e4dc-fc1a-45ab-9ed5-e65ef08b6d42
vspace

# ╔═╡ 05e4836b-5b49-45ef-a536-9c8e11c19d9c
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 47</div>
"""

# ╔═╡ 5a00909a-8279-46ef-8570-bbbb7adffcf4
md"""
## Treasury Bill Example

"""

# ╔═╡ bf50bdac-7aec-49eb-bc64-e176a240401b
vspace

# ╔═╡ a46dde58-14df-4722-a06f-08db697f63c5
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 48</div>
"""

# ╔═╡ 628ba57e-39ee-4072-8935-c44fae56b0bd
html"""
<p style="padding-bottom:2.5cm;background-color: #f2f3f4;border-style: solid; border-width: thin;"> </p>
"""

# ╔═╡ 291b8fd1-6434-4f43-a63d-41e38365667e
html"""
<p style="padding-bottom:2.5cm;background-color: #f2f3f4;border-style: solid; border-width: thin;"> </p>
"""

# ╔═╡ a3e9e4fe-e4f7-44c5-83b2-3bb3053bfd6c
# ╠═╡ show_logs = false
begin
md"""
- Quoted discount yield [% p.a.]: $(@bind yd_4 Slider(0:0.01:3, default=1.85, show_value=true))
- Par value [\$]: $(@bind par_4 Slider(100:1000, default=100, show_value=true))
- Settlement date: $(@bind settle_4 DateField(default=Date(2022,03,1)))
- Maturity date: $(@bind mat_4 DateField(default=Date(2022,3,31)))
"""
	daysMat = Date(mat_4) - Date(settle_4)
	px_4 = (1-yd_4/100*Dates.value(daysMat)/360)*par_4
	display("")
end

# ╔═╡ 462d4c52-be89-499f-bf8f-fd41eece8a80
Markdown.parse("""
- Assume a Treasury Bill is quoted with a discount yield of $(yd_4) percent.
- The Treasury Bill is priced for settlement on $(Date(settle_4)).
- The maturity date of the Treasury Bill is on $(Date(mat_4)).
- Suppose the Treasury Bill has par value of \$ $(par_4).
- Calculate the price of the Treasury Bill.
 """)

# ╔═╡ e0e1415f-dc86-4732-a9f8-1d761f847115
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 49</div>
"""

# ╔═╡ 371a326e-f13b-44ce-91e8-50d43b7ae59a
md"""
# Treasury STRIPS
"""

# ╔═╡ b7bdc144-7648-403f-bce7-2b6df6a8dd2f
md"""
- The Treasury does not issue **zero**-coupon notes or bonds. 
- However, by “stripping” coupon payments from Treasury bonds, zero coupon bonds are created synthetically. 
- The process of separating the interest on a bond from the underlying principal is called coupon stripping.

"""

# ╔═╡ 31c17b01-eb86-4fd4-82cc-3c31cf3020d8
vspace

# ╔═╡ a85f6c9b-0e19-447f-a930-ce2dcd9a7924
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 50</div>
"""

# ╔═╡ fe72e3e8-a2b4-43b2-811d-5f4fe2c8dd7a
LocalResource("./TreasurySTRIPS_1.png",:width => 1200) 

# ╔═╡ 3222f82c-b513-403b-b4c5-22d89144f894
vspace

# ╔═╡ f6eafc15-a7fb-4846-9c8f-331caaccc29b
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 51</div>
"""

# ╔═╡ 02748d79-5707-4130-9aae-0c6141e4f760
LocalResource("./TreasurySTRIPS_2.png",:width => 600) 

# ╔═╡ d01a85dd-1fd5-4b4e-9ff6-6de1f94d1752
vspace

# ╔═╡ 6fba2467-34cf-4ecc-990d-059e0d3e4a76
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 52</div>
"""

# ╔═╡ 1217e6ec-8479-4a85-b0e7-088eee30bc63
md"""
- Zero-coupon Treasury securities were first created in August 1982 by large dealer firms on Wall Street. 
- Today, all Treasury notes and bonds (fixed-principal and inflation-indexed) are eligible for stripping. 
- The zero-coupon Treasury securities created under the STRIPS program are direct obligations of the U.S. government.
- Strips created from the Treasury coupons are called **coupon STRIPS** and those from the principal are called **principal STRIPS**. 
"""

# ╔═╡ 12253ccf-59a3-4a54-85c3-ea53892e93fc
vspace

# ╔═╡ e0c6d184-d3c4-434e-8d50-51c7a85f8f94
html"""
	<div style="text-align: right;margin-top:1cm;"> Page 53</div>
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
        <input type="checkbox" value="" checked>Understand how prices for Treasury securities are quoted in secondary markets.<br><br>
	    <input type="checkbox" value="" checked>Know how to calculate accrued interest.<br><br>
	</fieldset>      
	"""
end

# ╔═╡ e7f999a0-3a90-4133-8f25-ece67767f779
vspace

# ╔═╡ 2ee2c328-5ebe-488e-94a9-2fce2200484c
md"""
## Reading
Fabozzi, Fabozzi, 2021, Bond Markets, Analysis, and Strategies, 10th Edition\
Chapter 7 and Chapter 2
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
CSV = "~0.10.9"
DataFrames = "~1.4.4"
HTTP = "~1.6.3"
HypertextLiteral = "~0.9.4"
LaTeXStrings = "~1.3.0"
PlotlyJS = "~0.18.10"
Plots = "~1.38.1"
PlutoUI = "~0.7.49"
XLSX = "~0.8.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0"
manifest_format = "2.0"
project_hash = "e6b5294034f24d28a3f8588307064ed81862baf6"

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

[[deps.AssetRegistry]]
deps = ["Distributed", "JSON", "Pidfile", "SHA", "Test"]
git-tree-sha1 = "b25e88db7944f98789130d7b503276bc34bc098e"
uuid = "bf4720bc-e11a-5d0c-854e-bdca1663c893"
version = "0.1.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Blink]]
deps = ["Base64", "Distributed", "HTTP", "JSExpr", "JSON", "Lazy", "Logging", "MacroTools", "Mustache", "Mux", "Pkg", "Reexport", "Sockets", "WebIO"]
git-tree-sha1 = "f3f568766c0e3646501d257b039dd48f18aba887"
uuid = "ad839575-38b3-5650-b840-f874b8c74a25"
version = "0.12.7"

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
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SnoopPrecompile", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d4f69885afa5e6149d0cab3818491565cf41446d"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.4.4"

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

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

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

[[deps.EzXML]]
deps = ["Printf", "XML2_jll"]
git-tree-sha1 = "0fa3b52a04a4e210aeb1626def9c90df3ae65268"
uuid = "8f5d6c58-4d21-5cfd-889c-e3ad7ee6a615"
version = "1.1.0"

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

[[deps.FunctionalCollections]]
deps = ["Test"]
git-tree-sha1 = "04cb9cfaa6ba5311973994fe3496ddec19b6292a"
uuid = "de31a74c-ac4f-5751-b3fd-e18cd04993ca"
version = "0.5.0"

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
git-tree-sha1 = "fd9861adba6b9ae4b42582032d0936d456c8602d"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.6.3"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hiccup]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "6187bb2d5fcbb2007c39e7ac53308b0d371124bd"
uuid = "9fb69e20-1954-56bb-a84f-559cc56a8ff7"
version = "0.2.2"

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

[[deps.JSExpr]]
deps = ["JSON", "MacroTools", "Observables", "WebIO"]
git-tree-sha1 = "b413a73785b98474d8af24fd4c8a975e31df3658"
uuid = "97c1335a-c9c5-57fe-bc5d-ec35cebe8660"
version = "0.5.4"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.Kaleido_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "43032da5832754f58d14a91ffbe86d5f176acda9"
uuid = "f7e6163d-2fa5-5f23-b69c-1db539e41963"
version = "0.2.1+0"

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

[[deps.Lazy]]
deps = ["MacroTools"]
git-tree-sha1 = "1370f8202dac30758f3c345f9909b97f53d87d3f"
uuid = "50d2b5c4-7a5e-59d5-8109-a42b560f39c0"
version = "0.15.1"

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

[[deps.Mustache]]
deps = ["Printf", "Tables"]
git-tree-sha1 = "821e918c170ead5298ff84bffee41dd28929a681"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.17"

[[deps.Mux]]
deps = ["AssetRegistry", "Base64", "HTTP", "Hiccup", "MbedTLS", "Pkg", "Sockets"]
git-tree-sha1 = "0bdaa479939d2a1f85e2f93e38fbccfcb73175a5"
uuid = "a975b10e-0019-58db-a62f-e48ff68538c9"
version = "1.0.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Observables]]
git-tree-sha1 = "6862738f9796b3edc1c09d0890afce4eca9e7e93"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.4"

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

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "5a6ab2f64388fd1175effdf73fe5933ef1e0bac0"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.0"

[[deps.Pidfile]]
deps = ["FileWatching", "Test"]
git-tree-sha1 = "2d8aaf8ee10df53d0dfb9b8ee44ae7c04ced2b03"
uuid = "fa939f87-e72e-5be4-a000-7fc836dbe307"
version = "1.3.0"

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

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "56baf69781fc5e61607c3e46227ab17f7040ffa2"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.19"

[[deps.PlotlyJS]]
deps = ["Base64", "Blink", "DelimitedFiles", "JSExpr", "JSON", "Kaleido_jll", "Markdown", "Pkg", "PlotlyBase", "REPL", "Reexport", "Requires", "WebIO"]
git-tree-sha1 = "7452869933cd5af22f59557390674e8679ab2338"
uuid = "f0f68f2c-4968-5e81-91da-67840de0976a"
version = "0.18.10"

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

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

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

[[deps.WebIO]]
deps = ["AssetRegistry", "Base64", "Distributed", "FunctionalCollections", "JSON", "Logging", "Observables", "Pkg", "Random", "Requires", "Sockets", "UUIDs", "WebSockets", "Widgets"]
git-tree-sha1 = "0eef0765186f7452e52236fa42ca8c9b3c11c6e3"
uuid = "0f1e0344-ec1d-5b48-a673-e5cf874b6c29"
version = "0.8.21"

[[deps.WebSockets]]
deps = ["Base64", "Dates", "HTTP", "Logging", "Sockets"]
git-tree-sha1 = "4162e95e05e79922e44b9952ccbc262832e4ad07"
uuid = "104b5d7c-a370-577a-8038-80a2059c5097"
version = "1.6.0"

[[deps.Widgets]]
deps = ["Colors", "Dates", "Observables", "OrderedCollections"]
git-tree-sha1 = "fcdae142c1cfc7d89de2d11e08721d0f2f86c98a"
uuid = "cc8bc4a8-27d6-5769-a93b-9d913e69aa62"
version = "0.6.6"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.XLSX]]
deps = ["Artifacts", "Dates", "EzXML", "Printf", "Tables", "ZipFile"]
git-tree-sha1 = "ccd1adf7d0b22f762e1058a8d73677e7bd2a7274"
uuid = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"
version = "0.8.4"

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

[[deps.ZipFile]]
deps = ["Libdl", "Printf", "Zlib_jll"]
git-tree-sha1 = "f492b7fe1698e623024e873244f10d89c95c340a"
uuid = "a5390f91-8eb1-5f08-bee0-b1d1ffed6cea"
version = "0.10.1"

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
# ╟─731c88b4-7daf-480d-b163-7003a5fbd41f
# ╟─a5de5746-3df0-45b4-a62c-3daf36f015a5
# ╟─3e995602-7a5e-45ce-a31d-449951af1aea
# ╟─588d53c3-b0ca-4dd7-aa0d-f0054fdf2c34
# ╟─6498b10d-bece-42bf-a32b-631224857753
# ╟─95db374b-b10d-4877-a38d-1d0ac45877c4
# ╟─a1071aa2-3a5f-4e0b-a42a-38fa027a85d8
# ╟─16805b96-9bb1-4ac8-a6af-fb03c57f1352
# ╟─93db6880-429c-4b9c-a807-eba600e03df1
# ╟─1fa89db5-8185-4c32-81ad-4cc7e4ec44c4
# ╟─aac27a3c-e90a-437f-a563-f81d41c8d3f7
# ╟─d3e308e6-b7f8-4f48-869f-f7dc34ec5b5b
# ╟─58ce2f05-63b2-45bc-8105-1cc709958e43
# ╟─39af52c6-ddb1-41ec-be5c-c0e31a2693bb
# ╟─6561b7a0-368c-43c6-ada9-36b83dc4a749
# ╟─15cb9e60-6e54-4f0e-abb2-9249bdc49677
# ╟─44e7c564-3738-4797-8904-b2bb709ac85e
# ╟─3e3c2581-333a-4be8-b07e-c9151a88fea7
# ╟─30ce6f74-1d7e-465d-abf1-245881fec53b
# ╟─395335f3-3f6c-4fbc-bf0b-9a238c8b6864
# ╟─4ad79093-2e8b-4fd7-bc1d-87388947ffde
# ╟─5d8ae74b-2030-4dd1-a59b-4513304e8826
# ╟─8410957f-b423-479d-8171-d0890476f6f5
# ╟─46566086-d518-49d9-b173-f66f2ea0e131
# ╟─2d37c722-c5bb-4462-a48d-f9374bed4449
# ╟─f01f940c-233c-4b90-882b-bd9d33c6b841
# ╟─b541d16f-59da-48dd-b7f6-a0cebd451256
# ╟─62a7d222-c32b-47f0-9b8f-e4c732650281
# ╟─64adcfde-8ade-4778-bb01-9d46ee836a55
# ╟─b294a20b-8710-49bb-a069-75dbc3f19ba6
# ╟─c3f25830-c6d2-4d77-bbd6-91024ee3363b
# ╟─0ee241a7-4dd4-4d7a-9f7f-1fc1691747b4
# ╟─e68723a6-a1d8-4a3f-8ba0-9acab5d764db
# ╟─f72ab26d-f986-4ab3-9f15-11cb33b65c69
# ╟─bbf515d0-e8a2-4391-8e86-41e814e3240a
# ╟─487c73a8-ee36-4fbe-95ea-12bcd86dc974
# ╟─b65c747b-f08a-408d-8e01-e921dcbd9056
# ╟─b5ed2793-df92-4f41-97e9-7533b35db4c0
# ╟─2200d50b-f23f-4764-85e1-d908b5aeeb1e
# ╟─e006ee99-b2e5-4705-83be-8846a14f3af7
# ╟─4576f508-91bd-4fdc-a62d-833d8428f78f
# ╟─6c57bd92-7d1d-41d3-88d5-0b2c191b7693
# ╟─9a1aa162-d274-4af7-8f13-5a9d6bab98b0
# ╟─4bccc40c-953a-4969-b47b-aea4b234919b
# ╟─176d61b1-02d9-4da6-a893-72aca3541f2c
# ╟─16c0a1d7-2454-466f-8700-d8c67fb53955
# ╟─729198d1-5795-4b70-85f8-f25717edc244
# ╟─301c4a13-814e-4853-aa5b-aac611cc40f0
# ╟─feb4fbca-0a01-445a-b4e1-d50b3f3525a3
# ╟─38981253-e191-4e30-9047-0723e1364978
# ╟─9aa0dec2-c1e1-41c5-9ad5-35b51e41128a
# ╟─3a2a5dea-4a07-4368-89c9-cde995b9964b
# ╟─d79b4d61-8211-4fca-a83c-46db3959d51e
# ╟─90195978-ac91-4efb-9df0-2403568e9e5b
# ╟─a4670db5-20e5-41cd-a2af-8dd15ce119f6
# ╟─16d95a82-743e-478c-a50d-36e800910883
# ╟─069242d7-b08b-423d-8e38-b5b0b690b8b1
# ╟─fa72f9cb-f8e6-4886-8cea-1d53a195067b
# ╟─be1e2ae2-8b05-42c7-bc54-18c9ff111854
# ╟─8464e17a-2f95-4bde-8c37-502359bb2dd8
# ╟─59023ef2-e4fb-4e41-9652-67f6a107e1b1
# ╟─4167b3d7-9ac5-45b2-86c9-daa8ce12f93b
# ╟─a7c9120b-ee24-48c2-904a-e40ef95fcffa
# ╟─148712ae-b638-45de-9ab1-96492f083439
# ╟─b7ea3fc2-5711-450e-a8d3-92bf19fd379e
# ╟─8f9498b5-a1cf-4be7-b0dd-41aad76c959b
# ╟─061b60b1-7c34-4a05-8f9f-89bb53e76923
# ╟─5b92a84b-ceed-4470-8768-aaa43746e9ea
# ╟─6ce18679-b433-4110-8ef4-0fd9135737f4
# ╟─c391eb33-e269-47dc-be8c-df8dcea7828d
# ╟─ed64ace8-a973-40e6-af92-d16876d7ac15
# ╟─1c3d5c02-4be2-4aff-bac8-bfde4aca679a
# ╟─c90f441d-09ca-4562-8f3f-d766e166d2a4
# ╟─ee211d3e-08c0-4a4c-8c79-8d5e709981ef
# ╟─2978a148-a9ef-4f78-a416-2dec50d25503
# ╟─b8026e29-5966-4cdd-84bc-33081f1775b7
# ╟─90501d6d-5c09-4bae-9415-dedd93dca242
# ╟─d440a3c8-6c8b-4eb9-ab4d-266917d50ee0
# ╟─d2d64702-6cce-4ffb-bdc2-928112af47c1
# ╟─3e793413-8c09-472b-8e76-768bdac21e19
# ╟─18026407-34e8-4a96-aaaf-410d495f9568
# ╟─362273d3-e019-4953-a1dd-21699f7a7def
# ╟─d31d75cb-142f-4e62-ab2c-80c2e19044b8
# ╟─864a77be-3ff8-4881-8c5b-944126cd3874
# ╟─20fc5dfa-55a2-4b90-b57d-9e57e2430ae1
# ╟─6fe25adf-8dd4-4391-ba0e-6224887dbf07
# ╟─9afffb09-8178-44df-bbf2-6c3ca4c15d11
# ╟─872bc4a3-9f35-463f-8894-57424c280260
# ╟─2cf47487-36c3-4a28-976e-06a58675b306
# ╟─5726e8ce-f069-4557-9d3b-533f211abc4a
# ╟─577c5da8-de61-4f41-96f3-957c4fa93cd2
# ╟─6acadc8a-dbb7-4193-9df7-09504755476b
# ╟─730a767d-f4e7-49a9-b830-9a22822733c9
# ╟─c800fc20-b59f-4072-ac64-79701ac75471
# ╟─cedc6044-5eb2-4e95-98c7-e5831597a258
# ╟─d43ce5da-dee3-4d44-a202-4f5f4770772b
# ╟─6130561b-7f4b-4982-b3b0-07a82f40cd0f
# ╟─9b6610ed-ae6e-4838-86fb-4835d40e9c11
# ╟─a4a0a069-80d6-4a13-a19d-56b200ca8545
# ╟─4491ba36-5eee-4b03-b056-da014bde0745
# ╟─6d6eb212-6e5c-4597-82e7-799798f05362
# ╟─b71c4b72-7004-4600-82d4-651179178a03
# ╟─a0b7115c-d6e5-4866-9e04-946e53e4c0c6
# ╟─0a49e623-79aa-4a8e-b35f-1efbfc342bef
# ╟─9360f593-37b6-4fbb-a1ea-7f6bcda0009a
# ╟─fd4aead4-bf25-4125-b094-6edce0e77b1e
# ╟─8e6ba2c0-65b0-4786-85cc-7025d9822b1c
# ╟─034067e2-9093-413b-bdcf-5e00ea0a4c56
# ╟─fcaff09a-c014-4fe9-81f8-f0fb72d99829
# ╟─8323c2cc-cc29-416b-aca4-798f7cc844ed
# ╟─e4333cc8-9d61-4df9-b3a9-d022ae9e43ee
# ╟─0a736d43-fc20-46ec-8cb4-01f16a44fd5e
# ╟─9119860b-2ada-411a-95e7-e1e56ae573c0
# ╟─67ddec44-a377-47eb-9e9e-1f53b88213d5
# ╟─74217076-17c8-4d6c-91d5-07d7c01d0d55
# ╟─8dc2cccb-a682-4c42-99fe-ccc91d3823d1
# ╟─50c74e0f-3cca-4b17-974f-af470fd3079e
# ╟─e74dfc8b-54a1-4e4a-ab0b-de1562ce197a
# ╟─c6df152f-9f62-4eb4-997e-afd9a0868c9e
# ╟─b32585ce-1455-4129-ba58-f0a00b9b1c3a
# ╟─0e493d71-bf2e-4300-bd14-2301bdad9efb
# ╟─41b91a85-ac56-4b36-87e1-b121c756417e
# ╟─df9c4a93-ceac-4ea9-8121-09affb1d534a
# ╟─7c6e09d1-f31b-4e38-933f-5a21c5428721
# ╟─fee22538-6370-4cb9-8c46-8e0143a9036c
# ╟─041eb11a-9da2-4e28-ace6-e20a13482c7d
# ╟─bbc947d4-0c02-4398-8daa-72d64f00b6a3
# ╟─cfd69cc4-d5aa-4c85-89aa-1356e24cf8b0
# ╟─afe4eecf-c83b-4ba1-9539-01bb4c05e8cd
# ╟─a459705c-ac04-4bec-a723-4cdc63a49cb3
# ╟─7b376a7e-215e-40af-82af-6be2762aa7eb
# ╟─4d039efd-c682-4abe-a2a4-8536ed97a3c7
# ╟─54a2b6c4-43b3-4d38-b9c7-75fb10976b90
# ╟─3751f38e-9a40-4d76-9d7e-b463721cb82d
# ╟─70661dd7-0acf-4b6c-b7dd-f4ad71c1cee9
# ╟─c40c66fe-2456-4403-bba1-6c636fbee403
# ╟─b3cf7cb4-3f9c-4d29-a061-e83987b93661
# ╟─6e1be79b-bfc7-444e-b660-e0d24a2cf5dd
# ╟─dc630486-a6f2-421b-b7f4-ff5f1b331485
# ╟─4bfa145f-af60-4364-87dd-eba26b00a013
# ╟─e4c4606f-bb51-43c6-98b7-73e1b133b251
# ╟─033c762c-2511-4185-86e4-b2ec5b181276
# ╟─156362e6-1a95-4fa1-97a0-a48397b4ad68
# ╟─a81f9bd5-374d-4238-af83-e39ab1f5982e
# ╟─bb8b0b23-4313-4764-96bd-c1e34aa09795
# ╟─a93b91d5-7239-4260-b57f-7afb02ee31c5
# ╟─03a7b4ed-a4ee-4d87-af1e-958c249c89c9
# ╟─a048f9e6-4826-41f6-828e-e585a9ac4d79
# ╟─dcb12edc-553b-4fe7-9525-a86d9fd5a78a
# ╟─25500a55-9c69-42d8-87bf-fb897b6de939
# ╟─71684c1d-0204-477b-a838-175f38e8c367
# ╟─05a80ef2-a74c-4fcc-ac5b-62953b8308b2
# ╟─5f2426ae-372f-4f12-b179-fb9f09e554ef
# ╟─9d874ab6-e3ec-4a87-8842-a8a8074b745c
# ╟─a92a604a-429b-4508-9820-c99839f3b431
# ╟─14053ee7-5149-485b-940a-6238b837ba68
# ╟─ab013f3d-433b-4511-b8df-349e9ce40691
# ╟─f214cc4b-384f-4e81-8de6-7a7f5d3ccf20
# ╟─549ff932-c2d7-4ab3-9e02-1b3c924a4482
# ╟─6c60f875-a3e2-44d8-92b6-076ad2b474ca
# ╟─ca7965dd-de83-4723-8f5f-139b2ad49de1
# ╟─de23b86d-91b7-4f5a-bf0a-d07afb50ac78
# ╟─4f6af650-763a-4c56-a564-d3c1447be1fd
# ╟─ec502b63-cefb-4576-9ae2-65ac39d6bc85
# ╟─3d8f424f-f097-4d46-b23e-d490455951a7
# ╟─9ebb7800-3463-43a5-ba5c-364c4f61742f
# ╟─28112b4a-fbeb-4409-b3f7-88578191a704
# ╟─443d90d3-a408-4f0a-b1c0-8e2cdfc1970a
# ╟─06d1335e-2596-4e97-98b4-744376238133
# ╟─2abaa6d1-3bc5-4bdb-ba74-77a4bc498c04
# ╟─e2e15eb3-c339-49ea-85b6-5436835cddea
# ╟─448e7b7e-b4b7-4eec-a331-f72f6aac7ff2
# ╟─4044d433-857f-47f6-8947-597935a981a1
# ╟─9b5ad19e-7e8c-4be0-8f9a-8fe4022765de
# ╟─61228793-317c-40a2-b9f8-cb661704f799
# ╟─e88cafc2-ad9a-4c46-bbc6-2f442ce0615a
# ╟─2ecb026c-c7ea-41a4-ac2b-b518b7fd5f05
# ╟─08083ddf-973d-4040-8878-f20fa484cb86
# ╟─7b091f73-2454-4690-b1f9-3f0008561da9
# ╟─a57f4d3f-e954-41fa-88a6-8d036a65ef07
# ╟─d5c4c319-a544-4546-847f-f5f384ee4494
# ╟─8128bfd1-aea6-42df-b05a-b3e4321cc879
# ╟─574ee503-37f4-4d27-8bc2-7688b60fe839
# ╟─d0b9d5ee-9120-4273-b8fc-714295bf8063
# ╟─2e81e8dc-cdef-4965-84a4-bdd1513d09f9
# ╟─f5f158d2-2378-4297-8072-ac00530980a1
# ╟─80e6068f-5876-47c0-a5e8-17125b54de63
# ╟─d11d60be-9909-47c6-8ce9-438e2cf28d6f
# ╟─9cc1e4dc-fc1a-45ab-9ed5-e65ef08b6d42
# ╟─05e4836b-5b49-45ef-a536-9c8e11c19d9c
# ╟─5a00909a-8279-46ef-8570-bbbb7adffcf4
# ╟─462d4c52-be89-499f-bf8f-fd41eece8a80
# ╟─bf50bdac-7aec-49eb-bc64-e176a240401b
# ╟─a46dde58-14df-4722-a06f-08db697f63c5
# ╟─628ba57e-39ee-4072-8935-c44fae56b0bd
# ╟─291b8fd1-6434-4f43-a63d-41e38365667e
# ╟─a3e9e4fe-e4f7-44c5-83b2-3bb3053bfd6c
# ╟─e0e1415f-dc86-4732-a9f8-1d761f847115
# ╟─371a326e-f13b-44ce-91e8-50d43b7ae59a
# ╟─b7bdc144-7648-403f-bce7-2b6df6a8dd2f
# ╟─31c17b01-eb86-4fd4-82cc-3c31cf3020d8
# ╟─a85f6c9b-0e19-447f-a930-ce2dcd9a7924
# ╟─fe72e3e8-a2b4-43b2-811d-5f4fe2c8dd7a
# ╟─3222f82c-b513-403b-b4c5-22d89144f894
# ╟─f6eafc15-a7fb-4846-9c8f-331caaccc29b
# ╟─02748d79-5707-4130-9aae-0c6141e4f760
# ╟─d01a85dd-1fd5-4b4e-9ff6-6de1f94d1752
# ╟─6fba2467-34cf-4ecc-990d-059e0d3e4a76
# ╟─1217e6ec-8479-4a85-b0e7-088eee30bc63
# ╟─12253ccf-59a3-4a54-85c3-ea53892e93fc
# ╟─e0c6d184-d3c4-434e-8d50-51c7a85f8f94
# ╟─53c77ef1-899d-47c8-8a30-ea38380d1614
# ╟─670e45a3-9d28-47ae-a6b6-a1b1c67a0a4c
# ╟─e7f999a0-3a90-4133-8f25-ece67767f779
# ╟─2ee2c328-5ebe-488e-94a9-2fce2200484c
# ╟─c3e429e4-e7e9-4db6-852c-906630f909a4
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
