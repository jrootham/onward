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
    this.state = { pathways: [] };
  }

  render() {
    return (
      <div className="decks-container">
        <BrowseDecksContainer>
          <HighSchoolDeckContainer />
          <PostSecondaryDeckContainer />
          <OccupationDeckContainer />
        </BrowseDecksContainer>
      </div>
    );
  }
}
