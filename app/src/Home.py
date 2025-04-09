##################################################
# reThread Home Page
# Entry point for each role
##################################################

# Set up basic logging infrastructure
import logging
logging.basicConfig(
    format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', 
    level=logging.INFO)
logger = logging.getLogger(__name__)

import requests
import pandas as pd
import streamlit as st
from modules.nav import SideBarLinks

# streamlit supports regular and wide layout (how the controls
# are organized/displayed on the screen).
st.set_page_config(layout = 'wide')

# If a user is at this page, we assume they are not 
# authenticated.  So we change the 'authenticated' value
# in the streamlit session_state to false. 
st.session_state['authenticated'] = False

# Use the SideBarLinks function from src/modules/nav.py to control
# the links displayed on the left-side panel. 
# IMPORTANT: ensure src/.streamlit/config.toml sets
# showSidebarNavigation = false in the [client] section
SideBarLinks(show_home=True)

# ***************************************************
#    The major content of this page
# ***************************************************

# set the title of the page and provide a simple prompt. 
logger.info("Loading Home page")
st.title("Welcome to reThread")
st.write('\n\n')
st.write("### Who are you logging in as?")

# For each of the user personas for which we are implementing
# functionality, we put a button on the screen that the user 
# can click to MIMIC logging in as that mock user. 

# Make a single API call for shopper data
try:
    # Replace with actual API call later
    pass
except Exception as e:
    st.error(f"Error fetching shopper data: {str(e)}")

# Make API call for seller data
try:
    # Replace with actual API call later
    pass
except Exception as e:
    st.error(f"Error fetching seller data: {str(e)}")

# Make API call for trend analyst data
try:
    trend_analyst_response = requests.get()
    if trend_analyst_response.status_code == 200:
        trend_analyst_data = admin_response.json()
        trend_analyst_firstname = trend_analyst_data["data"][0]["firstName"]
        trend_analyst_lastname = trend_analyst_data["data"][0]{"lastName"}
        trend_analyst_id = 1
    else:
        st.error(f"Error: {trend_analyst_response.status_code}")
        st.code(trend_analyst_response.text)
except Exception as e:
    st.error(f"Error fetching admin data: {str(e)}")

# Make API call for admin data
try:
    # Replace with actual API call later
    pass
except Exception as e:
    st.error(f"Error fetching admin data: {str(e)}")




if st.button("Act as {trend_analyst_firstname} {trend_analyst_lastname}, Trend Analyst",
            type = "primary",
            use_container_width=True):
    st.session_state["authenticated"] = True
    st.session_state["role"] = "trend_analyst"
    st.session_state["first_name"] = trend_analyst_firstname
    st.session_state["last_name"] = trend_analyst_lastname
    st.session_state["location_id"] = location_id
    st.session_state["user_id"] = user_id # Store the user ID
    logger.info("Logging in as Trend Analyst")
    st.switch_page("pages/00_TrendAnalyst_Home.py")