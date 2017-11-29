import PropTypes from 'prop-types';
import React from 'react';

export default class BrowseDecksContainer extends React.Component {

  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    return (
      <div className="browse-decks-container">
        { this.props.children }
      </div>
    );
  }
}
