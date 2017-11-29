import PropTypes from 'prop-types';
import React from 'react';

export default class BrowseDecks extends React.Component {
  static propTypes = {
    pathways: PropTypes.object.isRequired,
  };

  constructor(props) {
    super(props);
    this.state = { pathways: this.props.pathways };
  }

  render() {
    return (
      <div>

      </div>
    );
  }
}
