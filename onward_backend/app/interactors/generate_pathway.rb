class GeneratePathway
  include Interactor::Organizer

  organize NarrowOccupation, NarrowPostSecondary, NarrowHighSchool, PopulateHighSchool, PopulatePostSecondary, PopulateOccupation
end