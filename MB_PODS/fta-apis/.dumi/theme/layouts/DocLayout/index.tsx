import { Helmet, Outlet, useLocation, useOutlet } from '@@/exports';
import GlobalStyles from '@fta/dumi-theme-antd/dist/common/GlobalStyles';
import useLocaleValue from '@fta/dumi-theme-antd/dist/hooks/useLocaleValue';
import Homepage from '@fta/dumi-theme-antd/dist/layouts/HomePageLayout';
import SidebarLayout from '@fta/dumi-theme-antd/dist/layouts/SidebarLayout';
import Footer from '@fta/dumi-theme-antd/dist/slots/Footer';
import Header from '@fta/dumi-theme-antd/dist/slots/Header';
import SiteContext from '@fta/dumi-theme-antd/dist/slots/SiteContext';
import '@fta/dumi-theme-antd/dist/static/style';
import classNames from 'classnames';
import { useLocale, useRouteMeta, useSiteData } from 'dumi';
import React, { useContext, useEffect, useMemo, type FC } from 'react';

const DocLayout: FC = () => {
  const outlet = useOutlet();
  const locale = useLocale();
  const location = useLocation();
  const routeMeta = useRouteMeta();
  const title = useLocaleValue('title');
  const description = useLocaleValue('description');
  const { pathname, hash } = location;
  const { loading } = useSiteData();
  const { direction } = useContext(SiteContext);

  const is404Home = useMemo(
    () => pathname.startsWith('/index') && routeMeta.texts.length === 0,
    [pathname, routeMeta]
  );
  const content = useMemo(() => {
    if (
      ['', '/'].some((path) => path === pathname) ||
      ['/index'].some((path) => pathname.startsWith(path))
    ) {
      return (
        <React.Fragment>
          {outlet && !is404Home ? outlet : <Homepage />}
          <Footer />
        </React.Fragment>
      );
    }
    return routeMeta.frontmatter?.sidebar === false ? (
      <div>
        <Outlet />
      </div>
    ) : (
      <SidebarLayout>
        <Outlet />
      </SidebarLayout>
    );
  }, [routeMeta.frontmatter?.sidebar, outlet, pathname, is404Home]);

  // handle hash change or visit page hash from Link component, and jump after async chunk loaded
  useEffect(() => {
    const id = hash.replace('#', '');
    if (id) document.getElementById(decodeURIComponent(id))?.scrollIntoView();
  }, [loading, hash]);

  return (
    <div style={{display: 'flex', flexDirection:'column'}}>
      <Helmet encodeSpecialCharacters={false}>
        <html
          lang={locale.id}
          data-direction={direction}
          className={classNames(['dumi-theme-antd-root', { rtl: direction === 'rtl' }])}
        />
        <title>{`${title || 'dumi-theme-antd'}${description ? `-${description}` : ''}`}</title>
        <link
          sizes="144x144"
          href="https://gw.alipayobjects.com/zos/antfincdn/UmVnt3t4T0/antd.png"
        />
        <meta name="description" content={description} />
        <meta property="og:title" content={title} />
        <meta property="og:type" content="website" />
        <meta
          property="og:image"
          content="https://gw.alipayobjects.com/zos/rmsportal/rlpTLlbMzTNYuZGGCVYM.png"
        />
      </Helmet>
      <GlobalStyles />
      <Header />
      {content}
    </div>
  );
};

export default DocLayout;
