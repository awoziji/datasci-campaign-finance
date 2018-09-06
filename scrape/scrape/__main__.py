"""Main Module.

This can be called python -m scrape
"""
import csv
import argparse
import json
import logging
import os
import re
import time
import datetime

from robobrowser import RoboBrowser

from scrape.util import parse_cookie, mkdir

logging.basicConfig(level=logging.DEBUG)

URLS = {
    'measures': 'http://cal-access.sos.ca.gov/Campaign/Measures/',
    'committees': 'http://cal-access.sos.ca.gov/Campaign/Committees/',
}
'''
                  'http://cal-access.sos.ca.gov/Campaign/Committees/DetailContributionsReceivedExcel.aspx?id=1406518&session=2017',
    'committees': {
        'detail': 'http://cal-access.sos.ca.gov/Campaign/Committees/Detail.aspx?id=%(id)s&session=2017&view=%(view)s',
    },
        http://cal-access.sos.ca.gov/Campaign/Committees/Detail.aspx?id=1406518&session=2017&view=general
        http://cal-access.sos.ca.gov/Campaign/Committees/Detail.aspx?id=1406518&session=2017&view=electronic
'''


UA = 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.84 Safari/537.36'

THROTTLE_TIME = 0.1

class Scrape(object):
    def __init__(self, cookie):
        self._cookies = parse_cookie(cookie)
        self._data_dir = self._get_data_dir()
        self._ts = datetime.datetime.now().isoformat()

        self.measures = None
        self.props = []

        self.browser = RoboBrowser(
            history=True,
            parser='html5lib',
            user_agent=UA)
        self.browser.session.cookies.update(self._cookies)

    def _get_data_dir(self):
        dirname = os.path.dirname(os.path.abspath(__file__))
        if 'site-packages' not in dirname:
            data_dir = os.path.normpath(os.path.join(dirname, '..', 'data'))
        else:
            data_dir = os.path.normpath(os.path.join(os.getcwd(), 'data'))

        mkdir(data_dir)
        return data_dir


    def fetch_measures(self):
        self.browser.open(URLS.get('measures'))

        # get measures
        measures_raw = self.browser.find(id='ListElections1__ctl0')

        pattern = re.compile(r'^PROPOSITION (?P<prop>[0-9]+) - (?P<description>.*)')
        measures = []
        for a in measures_raw.find_all('a'):
            measure = pattern.match(a.text).groupdict()
            measure['url'] = a['href']
            measures.append(measure)

        self.measures = {
            'timestamp': self._ts,
            'measures': measures,
        }

        with open(os.path.join(self._data_dir, 'measures.json'), 'w') as f:
            f.write(json.dumps(self.measures, indent=4))




    def fetch_prop(self, prop, url):

        link =  os.path.join(URLS['measures'], url)

        self.browser.open(link)

        cf = self.browser.find(text='Campaign Finance:')
        body = cf.parent.parent

        tables = body.find_all('table')
        new = []
        data = {
            'prop': prop,
            'committees': {},
        }
        for table in tables:
            if table.find('span', text='COMMITTEE ID'):
                for row in table.find_all('tr'):
                    if row.find(text='COMMITTEE ID'):
                        continue
                    cols = row.find_all('td')
                    c = {}
                    c_id = cols[0].find('span').text
                    a = cols[1].find('a')
                    c['name'] = a.text
                    c['link'] = a['href']
                    c['position'] = cols[2].find('span').text
                    data['committees'][c_id] = c

        data['timestamp'] = self._ts

        prop_dir = os.path.join(self._data_dir, prop)
        mkdir(prop_dir)

        with open(os.path.join(prop_dir, 'prop.json'), 'w') as f:
            f.write(json.dumps(data, indent=4))

        self.props.append(data)
        return data


    def fetch_committee(self, prop, committee_id, link):
        committee_dir = os.path.join(self._data_dir, prop, committee_id)
        mkdir(committee_dir)
        '''
        url =  'http://cal-access.sos.ca.gov%s' % link
        print link

        self.browser.open(url)
        cf = self.browser.find(text='Campaign Finance:')
        body = cf.parent.parent
        '''

        '''

            'contributions',
            'expenditures',
            'late1',
            'late2',
            'late3',

        'http://cal-access.sos.ca.gov/Campaign/Committees/DetailContributionsReceivedExcel.aspx?id=1406518&session=2017',
        'http://cal-access.sos.ca.gov/Campaign/Committees/DetailContributionsMadeExcel.aspx?id=1406518&session=2017',
        'http://cal-access.sos.ca.gov/Campaign/Committees/DetailExpendituresMadeExcel.aspx?id=1406518&session=2017',
        'http://cal-access.sos.ca.gov/Campaign/Committees/DetailLateExcel.aspx?id=1406518&session=2017&view=LATE1',
        'http://cal-access.sos.ca.gov/Campaign/Committees/DetailLateExcel.aspx?id=1406518&session=2017&view=LATE2',
        'http://cal-access.sos.ca.gov/Campaign/Committees/DetailLateExcel.aspx?id=1406518&session=2017&view=LATE3',
        '''

        links =  {
            'contributions_received': '%(prefix)sDetailContributionsReceivedExcel.aspx?id=%(id)s&session=2017' % {
                'prefix': URLS.get('committees'), 
                'id': committee_id,
            },
            'contributions_made': '%(prefix)sDetailContributionsMadeExcel.aspx?id=%(id)s&session=2017' % {
                'prefix': URLS.get('committees'), 
                'id': committee_id,
            },
            'expenditures_made': '%(prefix)sDetailExpendituresMadeExcel.aspx?id=%(id)s&session=2017' % {
                'prefix': URLS.get('committees'), 
                'id': committee_id,
            },
            'late_and_5k_plus_contributions_received': '%(prefix)sDetailLateExcel.aspx?id=%(id)s&session=2017&view=LATE1' % {
                'prefix': URLS.get('committees'), 
                'id': committee_id,
            },
            'late_contributions_made': '%(prefix)sDetailLateExcel.aspx?id=%(id)s&session=2017&view=LATE2' % {
                'prefix': URLS.get('committees'), 
                'id': committee_id,
            },
            'late_independent_expenditures': '%(prefix)sDetailLateExcel.aspx?id=%(id)s&session=2017&view=LATE3' % {
                'prefix': URLS.get('committees'), 
                'id': committee_id,
            },
        }

        data = {}
        data['timestamp'] = self._ts
        for kind, link in links.iteritems():
            self.browser.open(link)
            csv_data = self.browser.find('body').text
            with open(os.path.join(committee_dir, '%s.csv' % kind), 'w') as f:
                f.write(csv_data)

            with open(os.path.join(committee_dir, '%s.csv' % kind), 'r') as f:
                #reader = csv.DictReader(f, delimiter='\t')
                reader = csv.reader(f, delimiter='\t')
                header = next(reader, None)
                rows = []
                for row in reader:
                    rows.append(row)

                data[kind] = {
                    'header': header,
                    'data': rows,
                }
            time.sleep(THROTTLE_TIME)

        with open(os.path.join(committee_dir, 'committee.json'), 'w') as f:
            f.write(json.dumps(data, indent=4))



def main():
    """Run main module."""
    logging.debug('scrape')

    parser = argparse.ArgumentParser()
    parser.add_argument("cookie", help='Copy full cookie from copy as curl')
    args = parser.parse_args()

    s = Scrape(args.cookie)
    s.fetch_measures()

    for m in s.measures.get('measures'):
        prop = s.fetch_prop(m.get('prop'), m.get('url'))
        for id, data in prop.get('committees').iteritems():
            s.fetch_committee(prop.get('prop'), id, data.get('link'))
            time.sleep(THROTTLE_TIME)
        time.sleep(THROTTLE_TIME)


if __name__ == '__main__':
    main()
