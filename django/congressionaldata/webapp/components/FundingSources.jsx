import React, { Component } from 'react';
import { Alert } from 'react-bootstrap/lib';
import Spinner from 'react-spinkit';

import BarChart from './charts/BarChart';
import LineChart from './charts/LineChart';
import Form from './Form';
import getData from '../api/getData';

/**
 * A component that takes a cadidate last name as form input and renders a bar
 * chart with the response data.
 */
class FundingSources extends Component {
    state = {
        formError: null,
        loading: null,
        data: [],
    }

    /**
     * Get the funding sources for a particular candidate.
     * @param {string} candidate - The candidate name.
     * @return {undefined}
     */
    getFundingSources = (candidate) => {
        this.setState({ loading: true });
        const count = 30;
        getData(`api/funding/sources/${candidate}/${count}`, (err, data) => {
            let formError;
            if (err) {
                formError = `${err}`;
            } else if (data.length === 0) {
                formError = `Could not find data for '${candidate}'.`;
            }
            this.setState({ formError, loading: false, data })
        })
    }

    render() {
        const { formError, loading, data } = this.state;
        // Display chart if form was used and API response was successful.
        const displayChart = loading !== null && !loading && !formError;
        return (
            <div>
                <Form
                    onPressEnter={this.getFundingSources}
                    controlLabel='Candidate Last Name'
                    placeholder='Ex: schwarzenegger'
                    error={formError}
                />
                {loading &&
                    <Spinner
                        name="ball-grid-pulse"
                        color="steelblue"
                    />
                }
                {displayChart &&
                    <BarChart data={data}
                        xKey={'donor'}
                        yKey={'sum'}
                        width={800}
                        height={800}
                        barColor='steelBlue'
                    /> &&
                    <LineChart data={data}
                        xKey={'donor'}
                        yKey={'sum'}
                        width={800}
                        height={800}
                    />
                }
            </div>
        )
    }
}

export default FundingSources;
