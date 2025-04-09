import streamlit as st

# ------------------------ Shopper ------------------------


# ------------------------ Seller ------------------------


# ------------------------ Trend Analyst ------------------------
def TrendAnalystNav():
    st.sidebar.page_link(
        "pages/02_TrendAnalyst_Home.py", label="Analyst Home", icon="📈"
    )
    st.sidebar.page_link(
        "pages/10_Search_Trends.py", label="Search Trends", icon="🔍"
    )
    st.sidebar.page_link(
        "pages/20_Price_Trends.py", label="Price Trends", icon="💲"
    )
    st.sidebar.page_link(
        "pages/30_Demographics.py", label="User Demographics", icon="🧍👥"
    )
    st.sidebar.page_link(
        "pages/40_Reports.py", label="Reports", icon="📄"
    )

# ------------------------ Admin ------------------------




def SideBarLinks(show_home=False):
    """
    Dynamically manages sidebar links based on the logged-in user's role.
    """
    
    # Add a logo to the sidebar
    st.sidebar.image("assets/logo.png", width=150)

    # Redirect unauthenticated users to Home
    if "authenticated" not in st.session_state:
        st.session_state.authenticated = False
        st.switch_page("Home.py")

    # Add the Home page link if specified
    if show_home:
        HomeNav()

    # Display role-specific navigation based on authentication and role
    if st.session_state["authenticated"]:
        role = st.session_state["role"]

        if role == "shopper":
            ShopperNav()
        elif role == "seller":
            SellerNav()
        elif role == "administrator":
            AdminNav()
        elif role == "trend_analyst":
            TrendAnalystNav()

        # Add a logout button for authenticated users
        if st.sidebar.button("Logout"):
            del st.session_state["role"]
            del st.session_state["authenticated"]
            st.switch_page("Home.py")
