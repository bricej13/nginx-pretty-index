<?xml version="1.0"?>
<!--
dirlist.xslt - transform nginx's into lighttpd look-alike dirlistings

I'm currently switching over completely from lighttpd to nginx. If you come
up with a prettier stylesheet or other improvements, please tell me :)

-->
<!--
Copyright (c) 2016 by Moritz Wilhelmy <mw@barfooze.de>
	All rights reserved

	Redistribution and use in source and binary forms, with or without
	modification, are permitted providing that the following conditions
	are met:
	1. Redistributions of source code must retain the above copyright
	notice, this list of conditions and the following disclaimer.
	2. Redistributions in binary form must reproduce the above copyright
	notice, this list of conditions and the following disclaimer in the
	documentation and/or other materials provided with the distribution.

	THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
	IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
	ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
	DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
	OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
	HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
	STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
	IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	POSSIBILITY OF SUCH DAMAGE.
-->
	<!--
		Copyright (c) 2021 by Abdus S. Azad <abdus@abdus.net>
		All rights reserved

		CHANGELOG:
		1. Add CSS for page beautification
		2. Make page Responsive
		3. Add Search Box
		4. Add File-type Icon
	-->
			<!DOCTYPE fnord [


			<!ENTITY nbsp "&#160;">]>
			<xsl:stylesheet
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xhtml="http://www.w3.org/1999/xhtml"
				xmlns="http://www.w3.org/1999/xhtml"
				xmlns:func="http://exslt.org/functions"
				xmlns:str="http://exslt.org/strings" version="1.0" exclude-result-prefixes="xhtml" extension-element-prefixes="func str">
			<xsl:output method="xml" version="1.0" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" indent="no" media-type="application/xhtml+xml"/>
			<xsl:strip-space elements="*" />
			<xsl:template name="size">
				<!-- transform a size in bytes into a human readable representation -->
				<xsl:param name="bytes"/>
				<xsl:choose>
					<xsl:when test="$bytes &lt; 1000">
						<xsl:value-of select="$bytes" />B


					</xsl:when>
					<xsl:when test="$bytes &lt; 1048576">
						<xsl:value-of select="format-number($bytes div 1024, '0.0')" />K


					</xsl:when>
					<xsl:when test="$bytes &lt; 1073741824">
						<xsl:value-of select="format-number($bytes div 1048576, '0.0')" />M


					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number(($bytes div 1073741824), '0.00')" />G


					</xsl:otherwise>
				</xsl:choose>
			</xsl:template>
			<xsl:template name="timestamp">
				<!-- transform an ISO 8601 timestamp into a human readable representation -->
				<xsl:param name="iso-timestamp" />
				<xsl:value-of select="concat(substring($iso-timestamp, 0, 11), ' ', substring($iso-timestamp, 12, 5))" />
			</xsl:template>
			<xsl:template match="directory">
				<tr class="hover:bg-gray-300 transition-colors ease-in-out border-b">
					<td></td>
					<td class="icon px-1 py-2">
						<img style="width: 20px; height: 20px" src="https://public.abdus.net/icons/folder.svg" />
					</td>
					<td class="px-1 py-2">
						<a href="{str:encode-uri(current(),true())}/">
							<xsl:value-of select="."/>
						</a>
					</td>
					<td class="px-1 py-2">
						<xsl:call-template name="timestamp">
							<xsl:with-param name="iso-timestamp" select="@mtime" />
						</xsl:call-template>
					</td>
					<td class="px-1 py-2 text-right"> - </td>
					<td class="px-1 py-2 text-right">Directory</td>
				</tr>
			</xsl:template>
			<xsl:template match="file">
				<tr class="hover:bg-gray-300 transition-colors ease-in-out border-b">
					<td class="px-1 py-2"><input type="checkbox" /></td>
					<td class="icon">
						<img style="width: 20px; height: 20px" src="https://public.abdus.net/icons/file.svg" />
					</td>
					<td class="px-1 py-2">
						<a href="{str:encode-uri(current(),true())}">
							<xsl:value-of select="." />
						</a>
					</td>
					<td class="px-1 py-2">
						<xsl:call-template name="timestamp">
							<xsl:with-param name="iso-timestamp" select="@mtime" />
						</xsl:call-template>
					</td>
					<td class="px-1 py-2 text-right">
						<xsl:call-template name="size">
							<xsl:with-param name="bytes" select="@size" />
						</xsl:call-template>
					</td>
					<td class="px-1 py-2 text-right">File</td>
				</tr>
			</xsl:template>
			<xsl:template match="/">
				<html>
					<head>
						<style type="text/css"></style>
						<meta name="viewport" content="width=device-width, initial-scale=1.0" />
						<meta charset="UTF-8" />

						<title>
								Index of

							<xsl:value-of select="$path"/>
						</title>
						<link href="https://unpkg.com/tailwindcss@^2/dist/tailwind.min.css" rel="stylesheet" />

					</head>
					<body class="container mx-auto">
						<div class="flex justify-between pb-10 pt-5">
							<div class="text-3xl font-extrabold text-gray-900 tracking-tight">
								<xsl:value-of select="$hostname" />
							</div>
							<input
								type="search"
								id="search-box"
								oninput="handleSearch()"
								placeholder="filter results"
								class="transition focus:outline-none focus:ring focus:border-blue-300 border border-gray-300 px-2 py-1"
								/>
						</div>
						<div class="list">
							<table summary="Directory Listing" class="w-full table-auto border-collapse">
								<thead>
									<tr class="z-20 sticky text-sm font-semibold text-gray-600 bg-white p-0">
										<th></th>
										<th></th>
										<th class="">Name</th>
										<th class="">Last Modified</th>
										<th class="">Size</th>
										<th class="">Type</th>
									</tr>
								</thead>
								<!-- uncomment the following block to enable totals -->
								<tfoot>
									<tr>
										<!-- five cols -->
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
									</tr>
								</tfoot>
								<tbody>
									<tr class="border-b">
										<td class="px-1 py-2"></td>
										<td class="px-1 py-2 icon"></td>
										<td class="px-1 py-2">
											<a href="../">🔙</a>
										</td>
										<td class="px-1 py-2"></td>
										<td class="px-1 py-2 text-right"> - </td>
										<td class="px-1 py-2 text-right">Special</td>
									</tr>
									<xsl:apply-templates />
								</tbody>
							</table>
						</div>
						<div class="flex justify-between py-4 text-sm text-gray-500">
						<div>
							<xsl:value-of select="count(//directory)"/> Directories, <xsl:value-of select="count(//file)"/> Files, <xsl:call-template name="size"> <xsl:with-param name="bytes" select="sum(//file/@size)" /> </xsl:call-template> Total
						</div>
						<div class="foot">powered by Nginx</div>
					</div>
						<script>
								document.querySelector("#search-box").style.display = '';

								function handleSearch() {
								const input = document.querySelector("#search-box");
								const filter = input.value.toUpperCase();
								const table = document.querySelector("table");
								const trGroup = [...table.querySelectorAll("tr")];

								trGroup.forEach(tr => {
								td = tr.querySelector("td:nth-child(2)");

								if (td) {
								const tdContent = td.textContent || td.innerText;

								if (tdContent.toUpperCase().includes(filter)) {
								tr.style.display = "";
								} else {
								tr.style.display = "none";
								}
								}
								})
								}
						</script>
					</body>
				</html>
			</xsl:template>
		</xsl:stylesheet>
