<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:pipeline="http://www.armatiek.com/xslweb/pipeline"
  xmlns:config="http://www.armatiek.com/xslweb/configuration"
  xmlns:req="http://www.armatiek.com/xslweb/request"
  xmlns:log="http://www.armatiek.com/xslweb/functions/log"
  xmlns:err="http://expath.org/ns/error"
  exclude-result-prefixes="#all" version="3.0" expand-text="yes">
  
  <xsl:param name="config:development-mode"/>
  <xsl:param name="data-uri-prefix" as="xs:string" required="yes"/>
  <xsl:param name="data-uri-prefix-devmode" as="xs:string" required="yes"/>
  
  <xsl:variable name="DUMP_REQUEST" as="xs:boolean" static="yes" select="false()"/>

  <xsl:variable name="TOPX2XIP" as="xs:string" select="'/topx2xip/'"/>
  <xsl:variable name="TOPX2XIPFOLDER" as="xs:string" select="'/topx2xip-folder/'"/>
  <xsl:variable name="TOPX2HTML" as="xs:string" select="'/topx2html/'"/>
  <xsl:variable name="DROID2HTML" as="xs:string" select="'/droid2html/'"/>
  <xsl:variable name="PLANETS2HTML" as="xs:string" select="'/planets2html/'"/>
  <xsl:variable name="SHOWREQUESTXML" as="xs:string" select="'/request/'"/>

  <xsl:variable name="conversions" as="xs:string+" select="($TOPX2XIP, $TOPX2HTML, $DROID2HTML, $PLANETS2HTML, $TOPX2XIPFOLDER, $SHOWREQUESTXML)"/>
  
  <xsl:template match="/">
    <xsl:sequence select="file:write('/tmp/request.xml', /)" xmlns:file="http://expath.org/ns/file" use-when="$DUMP_REQUEST"/>
    
    
    <xsl:sequence select="log:log('INFO', 'Dealing with request-path ' || /req:request/req:path)"/>
    
    <!-- Dit request-attribuut voorkomt dat we deze logica telkens moeten herhalen: -->
    <xsl:sequence select="req:set-attribute('data-uri-prefix', if ($config:development-mode) then $data-uri-prefix-devmode else $data-uri-prefix)"/>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="/req:request[starts-with(req:path, $TOPX2XIP)]">
    <pipeline:pipeline>
      <pipeline:transformer name="topx2xip" xsl-path="topx2xip.xslt"/>
      <pipeline:transformer name="xml-response" xsl-path="xml-response.xslt"/>
    </pipeline:pipeline>
  </xsl:template>
  
  <xsl:template match="/req:request[starts-with(req:path, $TOPX2XIPFOLDER)]">
    <pipeline:pipeline>
      <pipeline:transformer name="topx2xip" xsl-path="topx2xip-folder.xslt"/>
      <pipeline:transformer name="xml-response" xsl-path="xml-response.xslt"/>
    </pipeline:pipeline>
  </xsl:template>
  
  <xsl:template match="/req:request[starts-with(req:path, $TOPX2HTML)]">
    <pipeline:pipeline>
      <pipeline:transformer name="topx2html" xsl-path="topx2html.xslt"/>
      <pipeline:transformer name="html-response" xsl-path="html-response.xslt"/>
    </pipeline:pipeline>
  </xsl:template>
  
  <xsl:template match="/req:request[starts-with(req:path, $DROID2HTML)]">
    <pipeline:pipeline>
      <pipeline:transformer name="droid2html" xsl-path="droid2html.xslt"/>
      <pipeline:transformer name="html-response" xsl-path="html-response.xslt"/>
    </pipeline:pipeline>
  </xsl:template>
  
  <xsl:template match="/req:request[starts-with(req:path, $PLANETS2HTML)]">
    <pipeline:pipeline>
      <pipeline:transformer name="planet2html" xsl-path="planets2html.xslt"/>
      <pipeline:transformer name="html-response" xsl-path="html-response.xslt"/>
    </pipeline:pipeline>
  </xsl:template>
  
  <xsl:template match="/req:request[starts-with(req:path, $SHOWREQUESTXML)]">
    <pipeline:pipeline>
      <pipeline:transformer name="showrequest" xsl-path="show-request.xslt"/>
      <pipeline:transformer name="xml-response" xsl-path="xml-response.xslt"/>
    </pipeline:pipeline>
  </xsl:template>

  <xsl:template match="/req:request[not(replace(req:path, '^(/[^/]+/).*$', '$1') = $conversions)]">
    <pipeline:pipeline>
      <pipeline:transformer name="error" xsl-path="error.xslt">
        <pipeline:parameter name="message" type="xs:string">
          <pipeline:value>Geen transformatie gedefinieerd voor context-pad "{/req:request/req:webapp-path || /req:request/req:path}"</pipeline:value>
        </pipeline:parameter>
      </pipeline:transformer>
    </pipeline:pipeline>
  </xsl:template>
  
</xsl:stylesheet>