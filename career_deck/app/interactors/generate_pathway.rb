class GeneratePathway
  include Interactor::Organizer

  # organize NarrowOccupation, NarrowPostSecondary, NarrowHighSchool, PopulateHighSchool, PopulatePostSecondary, PopulateOccupation

  # organize PopulateHighSchoolCourses, SelectOccupation, SelectPostSecondary, SelectHighSchool

  organize PopulateHighSchoolCourses, NarrowOccupation, NarrowPostSecondary, PopulatePostSecondary, PopulateOccupation
end