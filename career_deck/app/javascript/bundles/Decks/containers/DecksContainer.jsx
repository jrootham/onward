import PropTypes from 'prop-types';
import React from 'react';
import BrowseDecksContainer from './BrowseDecksContainer'
import HighSchoolDeckContainer from './HighSchoolDeckContainer'
import PostSecondaryDeckContainer from './PostSecondaryDeckContainer'
import OccupationDeckContainer from './OccupationDeckContainer'


export default class DecksContainer extends React.Component {
  static propTypes = {};

  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    return (
      <div className="decks-container">
        <BrowseDecksContainer>
          <HighSchoolDeckContainer
            grade_9={ this.props.grade_9 }
            grade_10={ this.props.grade_10 }
            grade_11={ this.props.grade_11 }
            grade_12={ this.props.grade_12 }
          />
          <PostSecondaryDeckContainer post_secondary={ this.props.post_secondary } />
          <OccupationDeckContainer occupations={ this.props.occupation } />
        </BrowseDecksContainer>
      </div>
    );
  }
}
