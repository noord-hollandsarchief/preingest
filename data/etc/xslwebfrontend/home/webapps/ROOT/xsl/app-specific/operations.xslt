<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:req="http://www.armatiek.com/xslweb/request"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    xmlns:nha="http://noord-hollandsarchief.nl/namespaces/1.0"
    xmlns:session="http://www.armatiek.com/xslweb/session"
    expand-text="yes"
    version="3.0">
    
    <xsl:output method="html" version="5"/>
    
    <xsl:include href="commonconstants.xslt"/>
    <xsl:include href="commoncode.xslt"/>
    
    <xsl:template match="/req:request">
        <xsl:variable name="preingestguid" as="xs:string?" select="session:get-attribute($nha:preingestguid-session-key)"/>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Archiefbewerkingen</title>
                <link rel="stylesheet" type="text/css" href="{$nha:context-path}/css/gui.css" />
                <script language="javascript" src="{$nha:context-path}/js/gui.js" type="text/javascript"></script>
            </head>
            <body>
                <p><img src="img/logo.png" style="float: right; width: 10em"/></p>
                <xsl:choose>
                    <xsl:when test="exists($preingestguid)">
                        <xsl:call-template name="normal-body">
                            <xsl:with-param name="preingestguid" select="$preingestguid"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="error-body"/>
                    </xsl:otherwise>
                </xsl:choose>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template name="error-body">
        <h1>Fout</h1>
        <p class="error">Er is geen waarde in de sessie aanwezig met de naam van de folder met de uitgepakte bestanden.</p>
    </xsl:template>
    
    <xsl:template name="normal-body">
        <xsl:param name="preingestguid" as="xs:string" required="yes"/>
        
        <!-- TODO bij het opbouwen van de pagina controleren of de json/droid/csv-bestanden aanwezig zijn en zo de knoppen kleuren. -->
        
        <h1>Archiefbewerkingen</h1>
        <h2>Uitgepakte bestanden controleren en bewerken<br/>
            De folder met uitgepakte bestanden is {$preingestguid}</h2>
        <table>
            <tbody>
                <tr>
                    <th>Scan uitvoeren voor het detecteren van virussen</th>
                    <td><button onclick="doOperationsButton(this, '{$nha:actions-uri-prefix}', '{$preingestguid}', 'virusscan', 'ScanVirusValidationHandler.json', {$nha:refresh-value})">Viruscontrole&#x2026;</button></td>
                </tr>
                <tr style="display: none;">
                    <td colspan="2">
                        <div class="report">
                            <p style="font-weight: bold">Deze tekst is standaard verborgen maar
                                wordt zichtbaar zodra de bijbehorende actie voltooid is.</p>
                            <p>Nemo enim ipsam voluptatem, quia voluptas sit, aspernatur aut odit
                                aut fugit, sed quia consequuntur magni dolores eos, qui ratione
                                voluptatem sequi nesciunt, neque porro quisquam est, qui dolorem
                                ipsum, quia dolor sit, amet, consectetur, adipisci velit, sed quia
                                non numquam eius modi tempora incidunt, ut labore et dolore magnam
                                aliquam quaerat voluptatem. ut enim ad minima veniam, quis nostrum
                                exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid
                                ex ea commodi consequatur?</p>
                        </div>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <th>Benamingen van mappen en bestanden controleren op ongewenste karakters en gereserveerde bestandsnamen</th>
                    <td><button onclick="doOperationsButton(this, '{$nha:actions-uri-prefix}', '{$preingestguid}', 'naming', 'NamingValidationHandler.json', {$nha:refresh-value})">Bestandsnamen controleren&#x2026;</button></td>
                </tr>
                <tr style="display: none">
                    <td colspan="2"><div class="report">
                        <p style="font-weight: bold">Deze tekst is ook standaard verborgen; meer
                            voorbeelden nemen we echter niet op.</p>
                        <p>Je zou ook kunnen overwegen om kleuren te gebruiken om te laten zien
                            of iets goed of fout gegaan is (rood/groen).</p>
                    </div></td>
                    <td></td>
                </tr>
                <tr>
                    <th>Mappen en bestanden controlen op sidecarstructuur</th>
                    <!-- TODO naast SidecarValidationHandler_Archief.json heb je ook SidecarValidationHandler_Dossier.json, etc. -->
                    <td><button onclick="doOperationsButton(this, '{$nha:actions-uri-prefix}', '{$preingestguid}', 'sidecar', 'SidecarValidationHandler_Archief.json', {$nha:refresh-value})">Sidecarstructuur controleren&#x2026;</button></td>
                </tr>
                <tr>
                    <th>Droid voorbereiden om een map (en onderliggende objecten) te scannen voor metagegevens</th>
                    <td><button onclick="doOperationsButton(this, '{$nha:actions-uri-prefix}', '{$preingestguid}', 'profiling', '{$preingestguid}.droid', {$nha:refresh-value})">Droid voorbereiden&#x2026;</button></td>
                </tr>
                <tr>
                    <th>Droid metagegevens exporteren naar een CSV-bestand; vereist eerst de actie 'Droid voorbereiden&#x2026;'</th>
                    <td><button onclick="doOperationsButton(this, '{$nha:actions-uri-prefix}', '{$preingestguid}', 'exporting', '{$preingestguid}.droid.csv', {$nha:refresh-value})">CSV-bestand aanmaken&#x2026;</button></td>
                </tr>
                <tr>
                    <th>Droid metagegevens exporteren naar een PDF- of een XML-bestand; vereist eerst de actie 'Droid voorbereiden&#x2026;' [TODO]</th>
                    <td>
                        <select>
                            <option value="">Maak een keuze</option>
                            <option value="pdf">PDF</option>
                            <option value="droid">Droid-XML</option>
                            <option value="planets">Planets-XML</option>
                        </select>
                        <br/>
                        <button disabled="disabled" onclick="doOperationsButton(this, '{$nha:actions-uri-prefix}', '{$preingestguid}', 'reporting', 'TODOValidationHandler.json', {$nha:refresh-value})">PDF- of XML-bestand aanmaken&#x2026;</button></td>
                </tr>
                <tr>
                    <th>Bestanden controleren of deze in de 'greenlist' voorkomen. Vereist eerst de actie 'Droid metagegevens exporteren&#x2026;'</th>
                    <td><button onclick="doOperationsButton(this, '{$nha:actions-uri-prefix}', '{$preingestguid}', 'greenlist', 'GreenListHandler.json', {$nha:refresh-value})">Greenlistcontrole&#x2026;</button></td>
                </tr>
                <tr>
                    <th>Metadata bestanden controleren op de encoding</th>
                    <td><button onclick="doOperationsButton(this, '{$nha:actions-uri-prefix}', '{$preingestguid}', 'encoding', 'EncodingHandler.json', {$nha:refresh-value})">Encodingcontrole&#x2026;</button></td>
                </tr>
                <tr>
                    <th>Metadata valideren aan de hand van xml-schema (XSD) en schematron</th>
                    <td><button onclick="doOperationsButton(this, '{$nha:actions-uri-prefix}', '{$preingestguid}', 'validate', 'MetadataValidationHandler.json', {$nha:refresh-value})">Schema(tron)-controle&#x2026;</button></td>
                </tr>
                <tr style="display: none">
                    <td colspan="2"><div class="report">
                        <p style="font-weight: bold">De tekst zou een rapportage kunnen bevatten van alle schema- en schematron-errors, of een link naar een aparte pagina met die fouten.</p>
                    </div></td>
                    <td></td>
                </tr>
                <tr>
                    <th>Metadata bestanden transformeren naar XIP bestandsformaat</th>
                    <td>
                        <input type="text" size="40"
                            placeholder="Optioneel: preservica-id voor toevoeging" value="" />
                        <br/>
                        <button onclick="doOperationsButton(this, '{$nha:actions-uri-prefix}', '{$preingestguid}', 'transform', 'TransformationHandler.json', {$nha:refresh-value})">Omvormen naar XIP&#x2026;</button></td>
                </tr>
                <tr>
                    <th>Binary bestand bijwerken met PRONOM, Greenlist en Encoding gegevens (indien deze data beschikbaar zijn) [TODO]</th>
                    <td><button disabled="disabled" onclick="doOperationsButton(this, '{$nha:actions-uri-prefix}', '{$preingestguid}', 'updatebinary', 'TODO.json', {$nha:refresh-value})">Binary bijwerken&#x2026;</button></td>
                </tr>
                <tr>
                    <th>Bestanden laten verwerken door Preservica SIP Creator [TODO]</th>
                    <td><button disabled="disabled" onclick="doOperationsButton(this, '{$nha:actions-uri-prefix}', '{$preingestguid}', 'sipcreator', 'TODO.json', {$nha:refresh-value})">Sipcreator&#x2026;</button></td>
                </tr>
            </tbody>
        </table>
    </xsl:template>
</xsl:stylesheet>