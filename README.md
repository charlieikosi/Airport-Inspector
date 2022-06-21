# Airport-Inspector
A Web GIS Application for decision support in airstrip allocation and serviceability impact on rural areas in Papua New Guinea.
# Motivation for development
There are about 9.3 million people as of June18 2022 within Papua New Guinea with bulk of the population residing in remote parts of the country. Many of these places lack basic government services due to several compounding factors such as: rugged terrain, remoteness, limited economic activities, government funding, development focus areas, outdated demographics and inefficient service intervention sites. In addition to that, Papua New Guinea lacks research publications or reports that are accessible to make sound decisions for site intervention measures. Airstrips alone cover much of the country however, there is no way of measuring just how much of the country does it serve these rural populations. Questions like how far does a village have to be in order for it to benefit from proximity to an airstrip? Or, what areas of the country are segregated from airstrip serviceability? Responses to these questions are varied and limited to local area knowledge hence, introducing uncertainties which will have an impact on decision making.
Therefore, there is a need for a platform that can quantitatively measure and visualise airstrip serviceability areas for the country and function as a support tool for decision making.  The development of the Airport Inspector App which is a Web GIS implementation endeavours to quantify how much of an impact an airstrip provides in terms of serviceability on a provincial or national scale. This app is perhaps the first of its kind that creates an automation workflow with real time changes to modelled outputs whilst keeping it simple for ease of use by non-gis users. Most of the GIS workflow have been coded with computer programming language R to perform the automation while only requiring simple user input such as uploading spatial files or input numerical variables. It is simple intuitive and has the potential to be a powerful tool to target areas or discover areas that lack serviceability hence, adding value to funding proposals that incorporate the Airport Inspector outputs.
# App tools
## Panorama
This tool functions as an image processing tool that displays panoramic views of the airstrip. These are 360 degree image files which are geotagged to the location it was taken. The tool provides an immersive environment that has the same aesthetic look and function of google streetview. Currently under development to include an upload button to upload these 360 degree image files.
