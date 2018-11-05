# Meraki
Powershell script to pull Meraki configurations for your organization

Purpose
My purpose in creating this script was to be able to gather configuration data from Meraki equipment in my organization.  I am required to keep baselines, and check for changes on a periodic basis.  The Meraki Change Log does a nice job, but it does not solve the requirement of having a baseline for a device.
The configuration files that this script delivers are not perfect, but they are significantly better than screen shots.

Variables
This file uses variables that are based on the Meraki Public Sandbox.  Running this script as-is will pull information from that location. You will need to insert your own values for these variables in order to make it work in your environment.  
The first variable you'll need to update is the $apiKey.  This is available in your Meraki dashboard.

The other variables are found by running some of these commands.  I've noted in the code which queries return new values.  

You'll need to run these items one at a time, at first, in order to get your values.  I would suggest setting up a new script with the variable section, and the TLS1.2 command (basically the entire top portion of the script) along with the individual item you want to run.
Or...
Download Postman and work with the Meraki API to find these values.  I found Postman to be very valuable while I was writing this.  Going through the Meraki Tutorial is quick, and relatively easy, but necessary as the Postman interface only makes sense once you're used to it.
https://documentation.meraki.com/zGeneral_Administration/Other_Topics/The_Cisco_Meraki_Dashboard_API


File Output
Finally, I chose to export my files as XML for ease of reading.  And I then chose to concatenate these files together for ease of doc-compare.  

Good luck on your project.
