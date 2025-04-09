import logging
import streamlit as st
from modules.nav import NavBar

# Add nav bar
NavBar()

import streamlit as st
from datetime import datetime

st.set_page_config(layout="wide")
st.title("📊 Welcome, Fark!")
st.subheader("Trend Analyst Dashboard")

st.markdown("Use the tools below to explore trends across reThread and generate reports.")

col1, col2 = st.columns(2)
with col1:
    if st.button("🔍 Search Trends"):
        st.switch_page("pages/10_Search_Trends.py")
with col2:
    if st.button("💲 Price Trends"):
        st.switch_page("pages/20_Price_Trends.py")

col3, col4 = st.columns(2)
with col3:
    if st.button("🧍‍♂️ Demographics"):
        st.switch_page("pages/30_Demographics.py")
with col4:
    if st.button("📄 Reports"):
        st.switch_page("pages/40_Reports.py")

# Footer
st.markdown("---")
st.caption(f"Logged in as Fark Montenot • Trend Analyst • {datetime.now().strftime('%B %d, %Y')}")